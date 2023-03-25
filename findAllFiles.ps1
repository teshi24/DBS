$pathMainDirToAnalyze = "D:\source"
$pathFileMetaData = "D:\DBS_output_files.csv"
$pathDirMetaData = "D:\DBS_output_folders.csv"

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
"node_modules"
)

Function List-FileMetaData  
{  
    param([Parameter(Mandatory=$True)][string]$File = $(throw "Parameter -File is required."))  
  
    if(!(Test-Path -Path $File))  
    {  
        throw "File does not exist: $File"  
        Exit 1  
    }  
  
    $tmp = Get-ChildItem $File  
    $pathname = $tmp.DirectoryName  
    $filename = $tmp.Name  
  
    [HashTable]$hash = @{} 
    try{ 
        $shellobj = New-Object -ComObject Shell.Application  
        $folderobj = $shellobj.namespace($pathname)  
        $fileobj = $folderobj.parsename($filename)  
         
        for($i=0; $i -le 294; $i++)  
        {  
            $name = $folderobj.getDetailsOf($null, $i); 
            if($name){ 
                $value = $folderobj.getDetailsOf($fileobj, $i); 
                $hash[$($name)] = $($value) 
                #$hash[$($name)] = '' 
            } 
        }  
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
  
    if(!(Test-Path -Path $Dir))  
    {  
        throw "Dir does not exist: $Dir"  
        Exit 1  
    }
  
    $tmp = Get-ChildItem $Dir  
    $pathname = $tmp.DirectoryName
  
    [HashTable]$hash = @{} 
    try{ 
        $fso = New-Object -ComObject Shell.Application
        $folderobj = $fso.namespace($Dir)

        $folderSelf = $folderobj.self()
        
        $hash['name'] = $folderSelf.name()
        $hash['modifyDate'] = $folderSelf.modifyDate()
        $hash['path'] = $folderSelf.path()
        $hash['size'] = $folderSelf.size()
        $hash['type'] = $folderSelf.type()

    }finally{ 
        if($shellobj){ 
            [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$shellobj) | out-null 
        } 
    } 
 
    #return New-Object PSObject -Property $hash 
    return $hash 
}

function preparePrintingOfMetaDataForItem($path) {
    if (Test-Path -Path $path -PathType Leaf) {
        $hashTable = List-FileMetaData -File $path
        $allFiles.Add($hashTable) | out-null
    } else {
        $hashTable = List-DirMetaData -Dir $path
        $allFolders.Add($hashTable) | out-null
    }
}

function recursiveMetaDataSearch($path) {
    dir -Path $path -Filter *.* -ErrorAction SilentlyContinue -Exclude $excludeFolders | %{
        preparePrintingOfMetaDataForItem($_.FullName)
        if (Test-Path -Path $_.FullName -PathType Leaf) {
            return
        }
        recursiveMetaDataSearch($_.FullName)
    }
}

function saveMetaDataToFile($data, $path) {
    $data | ForEach-Object {New-Object PSObject -Property $_} | Export-Csv -NoTypeInformation -Path $path
}

echo "The directory will be analyzed (including subdirs): ${pathMainDirToAnalyze}"
echo "The directories with the following names will be ignored: ${excludeFolders}"
echo "Okay, let's go, please wait until the process is finished, this might take a while."

$allFiles = [System.Collections.ArrayList]::new()
$allFolders = [System.Collections.ArrayList]::new()

recursiveMetaDataSearch $pathMainDirToAnalyze

saveMetaDataToFile $allFiles $pathFileMetaData
saveMetaDataToFile $allFolders $pathDirMetaData

echo "The files, you've specified are written, please have a look into them: ${pathFileMetaData} and ${pathDirMetaData}"

#Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
