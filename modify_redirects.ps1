Import-CSV  D:\Data\redirectlist.csv -Header alias,destination | Foreach-Object{
    $nalias = $_.alias
    $ndestination = $_.destination

    Write-Host "For the alias: "$nalias 
    Write-Host "The new destination is: "$ndestination
  .\appcmd.exe set config $nalias -section:system.webServer/httpRedirect /destination:$ndestination
}

#needs to be executed as an admin on C:\WINDOWS\System32\inetsrv (better with PS ISE)
#D:\Data\redirectlist.csv: alias1,destination1 (1 per line)
