Set Execution-Policy  RemoteSigned
Get-ChildItem C:\*.* -Recurse | Select-String -Pattern "password" -AllMatches | Format-Table -Wrap -Property LineNumber,Filename,Path | Tee-Object -File C:\results.txt
Read-Host -Prompt "Press Enter to exit"
