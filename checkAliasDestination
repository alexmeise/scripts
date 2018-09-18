function Get-HostToIP($hostname) {     
    $result = [system.Net.Dns]::GetHostByName($hostname)     
    $result.AddressList | ForEach-Object {$_.IPAddressToString} 
} 
 
Get-Content "D:\Data\aliaslist.txt" | ForEach-Object {(Get-HostToIP($_)) >> D:\Data\Addresses.txt}

#if you ever need to modify several redirects (a list) you can run this script first to see if all of them are in the same server (or LB)
#it reads the alias list from D:\Data\aliaslist.txt (1 alias per line) and saves the list of destination IPs (1 ip per line) in D:\Data\Addresses.txt
