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


echo "The directories with the following names will be ignored"
echo $excludeFolders
echo "=================="


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



function handlePrintingOfAllData($path) {
    echo "handle ${path}"
    echo " "
    echo $_.FullName
    echo " "
    if (Test-Path -Path $_.FullName -PathType Leaf) {
        $list = List-FileMetaData -File $path
        ConvertTo-Csv -InputObject $list
        $path >> D:\DBS_output_files.txt
    } else {
        $list = List-DirMetaData -Dir $path
        ConvertTo-Csv -InputObject $list
        $path >> D:\DBS_output_directories.txt
    }
}

dir -Path D:\source -Filter *.* -ErrorAction SilentlyContinue -Exclude $excludeFolders | %{
   handlePrintingOfAllData($_.FullName)
}


function recursive($path) {
    dir -Path $path -Filter *.* -ErrorAction SilentlyContinue -Exclude $excludeFolders | %{
        handlePrintingOfAllData($_.FullName)
        if (Test-Path -Path $_.FullName -PathType Leaf) {
            return
        }
        recursive($_.FullName)
    }
}

#recursive D:\source*

#Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
