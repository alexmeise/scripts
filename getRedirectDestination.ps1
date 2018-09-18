#This little command when executed exports a csv with 2 columns: sitename, destination URL.
Import-Module WebAdministration -ErrorAction SilentlyContinue -ErrorVariable ImportError
Get-Website | select name,@{name='destination';e={(Get-WebConfigurationProperty -filter /system.webServer/httpRedirect -name "destination" -PSPath "IIS:\Sites\$($_.name)").value}} | Export-CSV D:\redirect.csv
