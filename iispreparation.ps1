<#
        .Date

            09.03.2017

        .Author

            Meise - mail@alexandermeise.com

        .Title

            init.ps1

        .Description

            Windows server preparation script for IIS Web Server role.

        .Functions

            Prepares the server for loadbalancing.

            Creates folder structure

            IIS Tunning 

            Set up needed modules

            Set up housekeeping    
               
    #>



#Bypass server security for executing PS scripts
try {

Set-ExecutionPolicy RemoteSigned -Force -ErrorVariable ExecutionError

}catch{

	Write-Warning "RUN AS ADMIN - Error trying to execute script: $ExecutionError"
}

#IMPORT MODULES (copy to server when needed)


Import-Module WebAdministration -ErrorAction SilentlyContinue -ErrorVariable ImportError
Copy-Item \\ingvsafas02\dml$\BI-IT-WPS\powershellmodules\NTFSSecurity\ 'C:\Program Files\WindowsPowerShell\Modules\NTFSSecurity\' -recurse -ErrorAction Ignore -ErrorVariable CopyError2
Import-Module NTFSSecurity 


If ($ProcessError){

Write-Warning -Message "The WebAdministration module could not be loaded: $ImportError "

}


#Remove the general * binding

try {

Get-WebBinding -Port 80 -Name "Default Web Site" | Remove-WebBinding 

}catch{

	Write-Warning "Error deleting binding"
}

#Adds the needed binding for loadbalancing

try {

#Set up a binding with the server ip as a hostname and hostheader.

$localIpAddress=((ipconfig | findstr [0-9].\.)[0]).Split()[-1]

New-WebBinding -Name "Default Web Site" -IPAddress $localIpAddress -Port 80 -HostHeader $localIpAddress -ErrorAction SilentlyContinue -ErrorVariable ProcessError 

}catch{

	Write-Warning "Error adding hostname binding for keep alive $ProcessError "
}

try {

#CREATE poll.html in C:\inetpub\wwwroot


$a= hostname;

ConvertTo-Html -Body $a | Out-File C:\inetpub\wwwroot\poll.html 

}catch{

	Write-Warning "Error creating poll.html"
}


#CREATE Folder structure

md -Path 'D:\DATA\some\folder' -ErrorAction SilentlyContinue -ErrorVariable FolderError1 
md -Path 'D:\DATA\some\folder' -ErrorAction SilentlyContinue -ErrorVariable FolderError2 
md -Path 'D:\DATA\some\folder'-ErrorAction SilentlyContinue -ErrorVariable FolderError3 
md -Path 'D:\DATA\some\folder' -ErrorAction SilentlyContinue -ErrorVariable FolderError4 
md -Path 'D:\DATA\sites' -ErrorAction SilentlyContinue -ErrorVariable FolderError5 

If ($FolderError1 -or $FolderError2 -or$FolderError3 -or$FolderError4 -or$FolderError5){

Write-Warning -Message "At least one of the folders was not created `n $FolderError1  `n $FolderError2  `n $FolderError3 `n $FolderError4  `n $FolderError5  `n" 

}

#Try to set Read NTFS Permissiones for Machine Users.

# REVIEEWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW

Add-NTFSAccess -Path D:\DATA -Account 'USERS' -AccessRights Read 

try {

#Configure maxHistories to 50 with appcmd

C:\Windows\system32\inetsrv\appcmd.exe set config -section:system.applicationHost/configHistory /maxHistories:"50" /commit:apphost 

}catch{

	Write-Warning "Could not set History to 50"
}

#Set up ISAPI tomcat module on D:\DATA\modules\tomcat (copy files to directory)

If ($CopyError -or $CopyError2){

Write-Warning -Message "Tomcat module was not copied: $CopyError " 

}
 
#Evaluates if the housekeeping task already exist, if not, creates it.

$task = Get-ScheduledTask -TaskName "housekeeping" -TaskPath \  -ErrorAction SilentlyContinue
If ($task.TaskName -cne "housekeeping" ){

    try {

        $Action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\Powershell.exe "D:\DATA\scripts\logfile_handling.ps1""       

        $Trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Sunday -At 3am
        
        $User = "SYSTEM"

        $Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings (New-ScheduledTaskSettingsSet) 

        $Task | Register-ScheduledTask -TaskName "housekeeping" -User $User

        $Task  

        }catch{

	Write-Warning "Could not create log-handling task"

}

}
