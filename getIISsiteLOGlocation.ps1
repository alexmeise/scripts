#COLUMNS
Import-Module WebAdministration
IIS:
cd Sites
Get-Itemproperty * -Name logFile.directory | select-object PSChildName,Value
#Set-ItemProperty “IIS:\Sites\<Sitename>” -name logFile.directory -value “<NewIISLogPath>”

#OTHER FORMAT 
#Import-Module WebAdministration
#foreach($WebSite in $(get-website))
#    {
#    $logFile="$($Website.logFile.directory)\w3scv$($website.id)".replace("%SystemDrive%",$env:SystemDrive)
#    Write-host "$($WebSite.name) [$logfile]"
#    } 
