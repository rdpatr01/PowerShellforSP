#Save the current value in the $p variable.
$p = [Environment]::GetEnvironmentVariable("PSModulePath")

#Add the new path to the $p variable. Begin with a semi-colon separator.
$p += ";D:\Russell'sScripts\Modules\"

#Add the paths in $p to the PSModulePath value.
[Environment]::SetEnvironmentVariable("PSModulePath",$p)

Import-Module Logging -Force

$Path = "D:\Logs\SPGroupSync\"
CreateLogFile -Path $Path


function SyncTargetGroup()
{
param([string]$sourceWeb,[string]$targetWeb,[string]$sourceGroup,[string]$targetGroup)

$srcweb = Get-SPweb $sourceWeb
$destWeb = Get-SPWeb $targetWeb

$srcGroup = $srcweb.SiteGroups[$sourceGroup].Users

$destGroup = $destWeb.SiteGroups[$targetGroup].Users

$OrphanUsers = $srcGroup | ?{$destGroup.UserLogin -notcontains $_.UserLogin}

foreach($user in $OrphanUsers)
{
    $EnsuredUser = $destWeb.EnsureUser($user.LoginName)
    $destWeb.SiteGroups[$targetGroup].AddUser($EnsuredUser)
}
}

function RemoveUsers()
{
param([string]$sourceWeb,[string]$targetWeb,[string]$sourceGroup,[string]$targetGroup)

$srcweb = Get-SPweb $sourceWeb
$destWeb = Get-SPWeb $targetWeb

$srcGroup = $srcweb.SiteGroups[$sourceGroup].Users

$destGroup = $destWeb.SiteGroups[$targetGroup].Users

$OrphanUsers = $destGroup | ?{$srcGroup.UserLogin -notcontains $_.UserLogin}

foreach($user in $OrphanUsers)
{
    $EnsuredUser = $destWeb.EnsureUser($user.LoginName)
    $destWeb.SiteGroups[$targetGroup].RemoveUser($EnsuredUser)
}
}
Logfile ("Starting to Sync Operation")
$intranet = ""
$SPIntra = Get-SPWeb $intranet
$SPList = $SPIntra.Lists[""]

$SPItems = $SPList.Items

foreach ($item in $SPItems)
{
  $d = $item['DestUrl']

   Logfile ("Starting to Sync $d")
   
   try{
    SyncTargetGroup -sourceWeb $item['SrcUrl'] -targetWeb $item['DestUrl'] -sourceGroup $item['SrcGroup'] -targetGroup $item['DestGroup']
    Logfile ("Sync Finished")
    }
    catch {
        Logfile ("Unable to Sync Group $item['SrcGroup'] to $item['DestGroup']")
    }
    try{
    RemoveUsers -sourceWeb $item['SrcUrl'] -targetWeb $item['DestUrl'] -sourceGroup $item['SrcGroup'] -targetGroup $item['DestGroup']
    Logfile ("Removal Completed")
     }
    catch {
        Logfile ("Unable to Remove Users from Group $item['SrcGroup'] to $item['DestGroup']")
    }

     Logfile ("--------------------------------------------")
    
}

Logfile ("Ending to Sync Operation")

