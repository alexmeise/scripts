# SHOWS WHERE THE LOGS ARE

Import-Module WebAdministration
IIS:
cd Sites
Get-Itemproperty * -Name logFile.directory | select-object PSChildName,Value

# UNIFIES LOG LOCATION

$LogPath = “D:\DATA\logs\accesslogs”
foreach($site in (dir iis:\sites\*))
{
New-Item $LogPath\$($site.Name) -type directory
Set-ItemProperty IIS:\Sites\$($site.Name) -name logFile.directory -value “$LogPath\$($site.Name)”
}

# SHOWS THE CHANGES

Get-Itemproperty * -Name logFile.directory | select-object PSChildName,Value
