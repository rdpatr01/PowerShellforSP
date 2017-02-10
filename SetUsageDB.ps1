 Add-PsSnapin Microsoft.SharePoint.PowerShell
 Write-Host "Data retention policy, which is set to 14 days by default.Going to set it to 3 days."
 Get-SPUsageDefinition
 $defs = Get-SPUsageDefinition
   
 Foreach($def in $defs)
 {
    Set-SPUsageDefinition –Identity $def.Name –DaysRetained 3
 } 
write-host "Now, open Central Admin and choose, Monitoring > Configure usage and health data collection > Log Collection Schedule>."
Write-host "Execute the two Timer jobs:"
Write-host "1)Microsoft SharePoint Foundation Usage Data Import"
Write-host "2)Microsoft SharePoint Foundation Usage Data Processing"
Write-host "The SQL logging database will now contain some free space"
Write-host "which your SQL DBA can ‘free-up’ within SQL Management Studio "
write-host "or running the ‘DBCC ShrinkFile’ T-SQL command."
Remove-PsSnapin Microsoft.SharePoint.PowerShell