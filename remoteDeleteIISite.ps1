# TO DELETE REDIRECTS IN THE NEW PLATFORM
# READS ALIAS FROM A CSV (ONE ALIAS PER LINE)
# TAKES A BACKUP AND DELETES THE SITE AND ITS FOLDER

$servers = "","","";

Write-Host ""
Write-Host "-----------------------------------------SCRIPT BEGIN---------------------------------------------------------------"
Write-Host ""
Write-Host "Reading alias list from C:\aliasToRemove.csv ... ... ..." -ForegroundColor Green
Write-Host ""

try{ #try to import


    Import-CSV  C:\\aliasToRemove.csv -Header alias | Foreach-Object{

        $alias = $_.alias
        $site = "redirect_"+$alias
        
            if ([string]::IsNullOrEmpty($alias)){
            Write-Host ""
            Write-Host "no alias was found on C:\aliasToRemove.csv please verify! (one alias per line expected)" -ForegroundColor Red
            Exit
            }#closes if
            

        Foreach ($server in $servers){
            &{
                Write-Host "------------------------------------------------------------------------------------"
                Write-Host "Trying to delete redirect:" $site -ForegroundColor Green " on " -NoNewLine 
                Write-Host $server -ForegroundColor Blue
                
                
                
                Invoke-Command -ComputerName $server -ArgumentList $site -ScriptBlock {
                param($site)
                                           
                           Remove-WebSite -Name $site  -ErrorVariable $errorwebsite                                                   
                           Remove-Item -Recurse D:\Data\sites\$site -ErrorVariable $errorfolder
                               
                           if(([string]::IsNullOrEmpty($errorwebsite) -or [string]::IsNullOrEmpty($errorfolder))){
                           Write-Host "::write::" $errorwebsite $errorfolder}
                               
                               
                } #ScriptBlock
                                  
            }#& 
               
        }#Foreach Server

        }#Foreachobject CSV

    }catch{#If the file does not exist.

    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName

    Write-Host "Does file exist? " $ErrorMessage -ForegroundColor Red 
    
    }#Ends catch

Write-Host ""
Write-Host "-----------------------------------------SCRIPT END--------------------------------------------------------------------"
Write-Host ""
