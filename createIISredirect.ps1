#Script grab list of names from csv and creates site and bindings
#gets Ip from server

#Use along with this line (before) to get list of sites: .\appcmd.exe list site /text:name | findstr redirect (this gives you a list of redirects on the server)
$ip=((ipconfig | findstr [0-9].\.)[0]).Split()[-1]
#uses the same pool for all redirects (create manually first!)
$pool = "redirect"


#variable preparation
$name = "sitename"
#Create the folder
new-item D:\DATA\sites\redirect_$name -itemtype directory
$site = "redirect_"+$name
$path = Join-Path -Path 'D:\Data\sites\' -ChildPath $site
#creates the site
New-Website -Name $site -ApplicationPool $pool -Force -PhysicalPath $path   
#removes wildcard bindings
Get-WebBinding -Port 80 -Name $site | Remove-WebBinding
#adds site bindings
New-WebBinding -Name $site -IPAddress $ip -Port 80 -HostHeader $name 
New-WebBinding -Name $site -IPAddress $ip -Port 80 -HostHeader $name"some.domain.com"

#starts site
Start-Website $site
