# DBS

Database Systems Projekt HSLU

## Usage Data Load Scripts

### How to use

1. Download Windows PowerShell as described in the modul description
    [TODO]: (add more detailed description / link)
2. Open Windows PowerShell ISE as an admin
3. Paste findAllFiles.ps1 script into the scripting area (or clone the directory to open it if you want)
4. adapt the main variables as necessary
   - $mainDirToAnalyse -> root of the filesystem which you want to analyse
   - $outputFiles -> make sure to use an existing path, if you do not have a D:\ drive
   - $excludeFolders -> add other folders which you do not want to include in the analysis (e.g. system relevant folders)
5. Save the script
6. Run the script
   - Note: this might take a while, especially when you are running it on a large drive / folder.
   - Note: If you immediately get this error:
      - CategoryInfo          : Sicherheitsfehler: (:) [], ParentContainsErrorRecordException
      - FullyQualifiedErrorId : UnauthorizedAccess
      you need to enable the script runs on your laptop temporarly
      Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
      don't forget to reset this after the script execution!!
      Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser
   - Note: if you get the Error "Error: Access Denied" after the script started, make sure that you are running it with admin rights.
7. Your data on your filesystem has been read and saved in the specified files. You can proceed with the db import.
