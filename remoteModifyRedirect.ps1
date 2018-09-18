# TO MODIFY REDIRECT IN THE NEW PLATFORM
# (ALL ENVIRONMENTS (QA and PROD) IF IT DOES NOT EXIST IN ONE SERVER IT JUST DOES NOT GET MODIFIED)
# ENTER "alias,http://www.newdestination.com" in the file C:\alias.csv (one alias,destination pair per line)
# RUN SCRIPT.
# IF THE REDIRECT SITS IN OTHER SERVERS JUST ADD THEM TO THE $servers ARRAY.
# IF MODIFICATION IS RIGHT ONLY GREEN TEXT IS SHOWN
# IF ALIAS DOES NOT EXIST IN SERVER ITEMNORFOUNDEXCEPTION IS SHOWN (AND TRIES IN NEXT SERVER)

$servers = "","","","","";

Write-Host ""
Write-Host ".: SCRIPT BEGIN :."
Write-Host ""
Write-Host "Reading alias,destination from file C:\aliasToModify.csv ... ... ..."
Write-Host ""

    try{ #try to import

        Import-CSV  C:\aliasToModify.csv -Header alias,destination | Foreach-Object{

            $alias = $_.alias
            $destination = $_.destination

            if ([string]::IsNullOrEmpty($alias) -or [string]::IsNullOrEmpty($destination)){

            Write-Host ""
            Write-Host "Either alias or destination is empty or format is wrong, please enter alias,destination pairs one per line" -ForegroundColor Red
            Exit

            }

            Foreach ($server in $servers){
            &{
            Write-Host "----------------------------------------------------------------------------------------------------------------------"
            Write-Host ""
            Write-Host "Trying to modify -> " $alias " <- destination to -> " $destination " <- in server ->  " -NoNewline
            Write-Host $server -ForegroundColor Blue -NoNewline 
            Write-Host " <- " 
            Write-Host ""

                Invoke-Command -ComputerName $server -ArgumentList $alias,$destination,$server -ScriptBlock {

                param($alias,$destination,$server)

                try{
                       Import-Module WebAdministration
                    & Set-WebConfiguration system.webServer/httpRedirect "IIS:\Sites\redirect_$alias" -Value @{enabled="true";destination=$destination;exactDestination="true";httpResponseStatus="Permanent";childOnly="true"}

                        Write-Host "SUCCESS! "$alias "was modified in" $server " and now points to URL: " $destination -ForegroundColor Green
                        Write-Host ""
                            

                        }catch{

                        $ErrorMessage = $_.Exception.Message
                        $FailedItem = $_.Exception.ItemName

                         
                        Write-Host "WARNING! " $alias "does not exist on server " $server " "$ErrorMessage -ForegroundColor Red 
                        Write-Host ""
                           
                        }#closes catch

                    }#&

                } #ScriptBlock 

            }#Foreach Server

        }#Import-CSV

    }catch{

    #If the file is not readable, empty or wrong formated.

    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName

    Write-Host "Does file exist? " $ErrorMessage -ForegroundColor Red 
    }

Write-Host ""
Write-Host ".: SCRIPT END :."
Write-Host ""
