$servers = ""; #IMPORTANT TO TAKE A LOOK HERE BEFORE RUNNING THE SCRIPT

Write-Host ""
Write-Host ".: SCRIPT BEGIN :."
Write-Host ""
Write-Host "Reading website C:\websiteSTOP.csv ... ... ..."
Write-Host ""

    try{ #try to import

        Import-CSV  C:\websiteSTOP.csv -Header website | Foreach-Object{

            $website = $_.website
            

            if ([string]::IsNullOrEmpty($website)){

            Write-Host ""
            Write-Host "Website list in wrong format or empty, script expects 1 site per line" -ForegroundColor Red
            Exit

            }
            
                      
            Foreach ($server in $servers){
            &{
            Write-Host "----------------------------------------------------------------------------------------------------------------------"
            Write-Host ""
            Write-Host "Trying to stop -> " $website " <- in server ->  " -NoNewline
            Write-Host $server -ForegroundColor Blue -NoNewline 
            Write-Host " <- " 
            Write-Host ""

                Invoke-Command -ComputerName $server -ArgumentList $website -ScriptBlock {

                param($website)
                Import-Module WebAdministration
                try{
                     
                    & Stop-Website -Name $website

                        Write-Host "SUCCESS! "$website "was STOPPED in" $server -ForegroundColor Green
                        Write-Host ""
                            

                        }catch{

                        $ErrorMessage = $_.Exception.Message
                        $FailedItem = $_.Exception.ItemName

                         
                        Write-Host "WARNING!" $website "does not exist on server " $server " " $ErrorMessage 
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
