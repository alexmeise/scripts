#COLUMNS
Import-Module WebAdministration
IIS:
cd Sites
Get-Itemproperty * -Name logFile.directory | select-object PSChildName,Value
#Set-ItemProperty “IIS:\Sites\<Sitename>” -name logFile.directory -value “<NewIISLogPath>”

<#
#OTHER FORMAT 
Import-Module WebAdministration
Foreach($WebSite in $(get-website))
    {
    $logFile="$($Website.logFile.directory)\w3scv$($website.id)".replace("%SystemDrive%",$env:SystemDrive)
    Write-host "$($WebSite.name) [$logfile]"
    } 

#OTHER FORMAT
Get-Website * | % { $_.Name, $_.logFile.Directory}

#IF you want to edit the log location use the following :

Import-Module WebAdministration
$LogPath = “D:\DATA\logs\accesslogs”
foreach($site in (dir iis:\sites\*))
{
New-Item $LogPath\$($site.Name) -type directory
Set-ItemProperty IIS:\Sites\$($site.Name) -name logFile.directory -value “$LogPath\$($site.Name)”
}

#>
