$mainDirToAnalyze = "D:\"
$outputFileForFileMetaData = "D:\DBS_output_files.csv"
$outputFileForDirMetaData = "D:\DBS_output_folders.csv"

[string[]]$excludeFolders = @(
".gradle",
".idea",
".vscode",
".git",
"cache",
"build",
"target",
"temp",
"lib",
"node_modules",
"src",
"test",
"java",
".m2"
)

if(!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 echo "Admin Rights are required to run this script!"
 Exit
}


Function List-FileMetaData 
{  
    param([Parameter(Mandatory=$True)][string]$File = $(throw "Parameter -File is required."))
  
    $tmp = Get-ChildItem $File  
    $pathname = $tmp.DirectoryName  
    $filename = $tmp.Name  

    [HashTable]$hash = @{} 
    try{ 
        $shellobj = New-Object -ComObject Shell.Application  
        $folderobj = $shellobj.namespace($pathname)
        $fileobj = $folderobj.parsename($filename)

        $hash['folder'] =  $folderobj.getDetailsOf($fileobj, 191)
        $hash['name'] = $fileobj.name()
        $hash['lastAccessedTSD'] = $folderobj.getDetailsOf($fileobj, 5)
        $hash['lastModifiedTSD'] = $fileobj.modifyDate()
        $hash['creationTSD'] = $folderobj.getDetailsOf($fileobj, 4)
        $hash['sizeInBytes'] = $fileobj.size()
        $hash['sizeAsString'] = $folderobj.getDetailsOf($fileobj, 1)
        $hash['filetype'] = $folderobj.getDetailsOf($fileobj, 164)
        
    }finally{
        if($shellobj){ 
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$shellobj) | out-null 
        }
    }
 
    #return New-Object PSObject -Property $hash 
    return $hash 
}  


Function List-DirMetaData  
{  
    param([Parameter(Mandatory=$True)][string]$Dir = $(throw "Parameter -Dir is required."))
  
    $tmp = Get-ChildItem $Dir  
    $pathname = $tmp.DirectoryName
  
    [HashTable]$hash = @{} 
    try{ 
        $fso = New-Object -ComObject Shell.Application
        $folderobj = $fso.namespace($Dir)

        $folderSelf = $folderobj.self()
        
        $hash['name'] = $folderSelf.name()
        $hash['lastModifiedTSD'] = $folderSelf.modifyDate()
        $hash['path'] = $folderSelf.path()
        #$hash['size'] = $folderSelf.size()
        #$hash['type'] = $folderSelf.type()

    }finally{ 
        if($shellobj){ 
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$shellobj) | out-null 
        } 
    } 
 
    #return New-Object PSObject -Property $hash 
    return $hash 
}

function isPathToFile($path) {
  return (Test-Path -Path $path -PathType Leaf);
}

function preparePrintingOfMetaDataForItem($path) {
    if (isPathToFile($path)) {
        $hashTable = List-FileMetaData -File $path
        $hashTable["folderID"] = $Global:currentFolderID
        $allFiles.Add($hashTable) | out-null
    } elseif (Test-Path -Path $path) {
        $hashTable = List-DirMetaData -Dir $path
        $hashTable["parentFolderID"] = $Global:currentFolderID
        $Global:currentFolderID = $Global:currentFolderID + 1
        $hashTable["parentFolderID"] = $Global:currentFolderID

        $allFolders.Add($hashTable) | out-null
    } else {
        throw "Path not recognized and ignored (probably containing unallowed characters, such as '[]'): " + $path
    }
}

function recursiveMetaDataSearch($path) {
    dir -Path $path -ErrorAction SilentlyContinue -Exclude $excludeFolders | %{
        try {
            preparePrintingOfMetaDataForItem($_.FullName)

            if ((isPathToFile($_.FullName))) {
                return
            }

            recursiveMetaDataSearch($_.FullName)
        } catch {
            echo "WARN: $($_)"
        }
    }
}

function saveMetaDataToFile($data, $path) {
    $data | ForEach-Object {
    New-Object PSObject -Property $_
    } | Export-Csv -NoTypeInformation -Path $path -Encoding UTF8
}

echo "The directory will be analyzed (including subdirs): ${mainDirToAnalyze}"
echo "The directories with the following names will be ignored: ${excludeFolders}"
echo "Okay, let's go, please wait until the process is finished, this might take a while."
echo ""

$ValueOfDisableLastAccessBeforeScript = ((fsutil behavior query disablelastaccess) -split '(?=\d)',2).Get(1)[0]
$tempValueOfDisableLastAccess = 3

echo ""
fsutil behavior set disablelastaccess $tempValueOfDisableLastAccess
echo ""
echo "FYI: NTFS Option DisableLastAccess has been changed from ${ValueOfDisableLastAccessBeforeScript} to ${tempValueOfDisableLastAccess}, to ensure that the value 'Last Access' is not currupted by executing this script."
echo "     Note: If you stop this script for any reason by yourself before it sais is finished, you need to take care of the cleanup yourself."
echo ""

try {
    $allFiles = [System.Collections.ArrayList]::new()
    $allFolders = [System.Collections.ArrayList]::new()
    $currentFolderID = 1;

    echo "scanning directory"
    echo $mainDirToAnalyze
    echo ""
    dir -Path $mainDirToAnalyze | ForEach-Object {
        $_.FullName
        preparePrintingOfMetaDataForItem($_.FullName)
        recursiveMetaDataSearch $_.FullName
    }

    echo "save output to file"
    echo ""

    saveMetaDataToFile $allFiles $outputFileForFileMetaData
    saveMetaDataToFile $allFolders $outputFileForDirMetaData

    echo "The files, you've specified are written, please have a look into them: ${outputFileForFileMetaData} and ${outputFileForDirMetaData}"
    echo ""
}
finally {
    echo ""
    fsutil behavior set disablelastaccess $ValueOfDisableLastAccessBeforeScript
    echo ""
    echo "Thank you for your patience!"
}
#Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
