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
                $hash["" + $i + " " + $($name)] = $($value)
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

<#
Name                           Value                                                                       
----                           -----                                                                       
Relevanz                                                                                                   
Elementtyp                     PNG-Datei                                                                   
Erstelldatum                   21.02.2023 13:17                                                            
---- Ist gelöscht                                                                                               
Letzter Besuch                                                                                             
Ordnerpfad                     D:\                                                                         
Letzter Zugriff                30.04.2023 10:21                                                            
Priorität                                                                                                  
Änderungsdatum                 21.02.2023 13:17                                                            
Name                           FehlerCode_OneDrive.PNG                                                     
Ordnername                     D:\                                                                         
Erkannter Typ                  Bild                                                                        
Art                            Bild                                                                        
---- Dateianzahl                                                                                                
Größe                          31.3 KB                                                                     
Dateiname                      FehlerCode_OneDrive.PNG                                                     
Typ                            PNG-Datei                                                                   
Ordner                         D:\                                                                         
Dateierweiterung               .PNG                                                                        
Pfad                           D:\FehlerCode_OneDrive.PNG                                                  




291 Relevanz                                                         
2 Elementtyp                   PNG-Datei         
4 Erstelldatum                 21.02.2023 13:17                                                          
200 Letzter Besuch                                                                                         
191 Ordnerpfad                 D:\                                                                         
5 Letzter Zugriff              30.04.2023 11:40                                                            
276 Priorität                                                                                              
3 Änderungsdatum               21.02.2023 13:17                                                            
0 Name                         FehlerCode_OneDrive.PNG
190 Ordnername                 D:\                                                                         
9 Erkannter Typ                Bild                                                                        
11 Art                         Bild                                                                        
1 Größe                        31.3 KB                                                                     
165 Dateiname                  FehlerCode_OneDrive.PNG                                                     
196 Typ                        PNG-Datei                                                                   
192 Ordner                     D:\                                                                         
164 Dateierweiterung           .PNG                                                                        
194 Pfad                       D:\FehlerCode_OneDrive.PNG

#>