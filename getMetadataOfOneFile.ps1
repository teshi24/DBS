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
 
#example usage  
List-FileMetaData -File "D:\FehlerCode_OneDrive.PNG"