[string[]]$excludeFolders = @(
#".idea*"
"Android"
)

echo $excludeFolders

 dir -Path D:\source* -Filter *.* -Recurse -ErrorAction SilentlyContinue -Exclude $excludeFolders | %{
    $allowed = $true
    foreach ($exclude in $excludeFolders) {
        if (($_.FullName).Contains($exclude)) { 
            $allowed = $false
            break
        }
    }
    if ($allowed) {
        $_.FullName
    }
 }

#Get-ChildItem -Path D:\source* -Filter *.* -Recurse -ErrorAction SilentlyContinue -Force
#Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser