cls
Write-Host "Loading SharePoint Commandlets"
Add-PSSnapin Microsoft.SharePoint.PowerShell -erroraction SilentlyContinue
Write-Host -ForegroundColor Green " Commandlets Loaded ... Loading Variables"
Write-Host
[array]$servers= Get-SPServer | ? {$_.Role -eq "Application"}
$farm = Get-SPFarm
foreach ($server in $servers)
{
    Write-host "Clearing Dist Cache Items for $server"
    Clear-SPDistributedCacheItem -ContainerType DistributedLogonTokenCache 
    Write-Host "Completed $server"
}
Write-Host -ForegroundColor Green "Distributed Cache Item has been cleared Across the Farm"
Start-Sleep -Seconds 5
Write-host