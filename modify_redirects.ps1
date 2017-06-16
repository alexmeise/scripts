#execute in C:\Windows\System32\inetsrv> as admin
#Creates backup folder if not present
if (!(Test-Path D:\Data\backups)){
mkdir D:\Data\backups
 Write-Host "Backup folder created"
 Write-Host ""
 }
# reads alias from csv like: alias,URL 
Import-CSV  D:\Data\alias.csv -Header alias,destination | Foreach-Object{
    
    #prepare alias destination and folder
    $nalias = $_.alias
    $ndestination = $_.destination
    $folder = "redirect_"+$nalias
    
    
    #if web.config exists
    if ((Test-Path D:\Webroot\${folder}\web.config)){
    
    #write the process    
    Write-Host "--------------------------------------"
    Write-Host "Processing alias: "$nalias
   
    #make a backup 
    Copy-Item D:\Webroot\${folder}\web.config D:\DATA\backups\${folder}.backup
    Write-Host "A BACKUP of the web.config was performed, please find it in D:\Data\backups"
    
    #checks the old destination and print it
    #$old = .\appcmd.exe list config $folder -section:system.webServer/HttpRedirect 
    #$parsed = [regex]::matches($old,'(?<=\").+?(?=\")').value
    #Write-Host "The current destination is: " $parsed[2]
   
    #prints the new destination and modifies it
    Write-Host "The new destination will be: "$ndestination
    .\appcmd.exe set config $folder -section:system.webServer/httpRedirect /destination:$ndestination
    Write-Host ""
    }else{
     Write-Host "------------------------------------------------------"
     Write-Host $nalias "does not exist or could not be found on this server" 
     Write-Host "------------------------------------------------------"     
     }
    
}
