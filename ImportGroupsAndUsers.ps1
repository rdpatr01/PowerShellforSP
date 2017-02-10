param (
    [string] $siteurl = "",
	[string] $importtogroups = "D:\Russell'sScripts\Users.csv",
	[string] $createspgroups = "",
	[string] $importwithperm = ""
)

if ($siteurl -eq "")
{
	$siteurl = Read-Host "Site url";
}

[Void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint");

Write-Host -ForegroundColor green "Opening SharePoint site...";

$site = New-Object Microsoft.SharePoint.SPSite($siteurl)
$web = $site.RootWeb;
function LogFile {
	Param ([string]$logstring)

	Add-content $Logfile -value $logstring
        
}
$a = Get-Date -UFormat "%Y%m%d-%H%M"
$FileName = $a + ".txt"
$Path = 'D:\Russell''sScripts\MergedLogs\'
$file = $a + "AddedUsers.txt"
$LogFile = $Path + $file

if ($createspgroups -ne "") 
{
	Write-Host -ForegroundColor green "Importing sharepoint groups from $createspgroups";
	ipcsv $createspgroups | foreach { 
		$group = $_.GroupName;
		$perm = $_.Permissions;
		$owner = $_.Owner;
		if ($owner -eq "") { $owner = $web.CurrentUser.LoginName }
		LogFile ("--------------------------------------")
        LogFile ($web.Title)
		Write-Host -ForegroundColor green "  $group (owner = $owner, perm = $perm)"
		$exists = $web.SiteGroups | where { $_.Name -eq $group }
		if ($exists -eq $null)
		{
			# Create group
			$web.SiteGroups.Add($group, $web.EnsureUser($owner), $null, "");
			# Give permissions to the group
			$assign = New-Object Microsoft.SharePoint.SPRoleAssignment($web.SiteGroups[$group]);
			$assign.RoleDefinitionBindings.Add($web.RoleDefinitions[$perm])
			$web.RoleAssignments.Add($assign)
		} 
		else 
		{
			Write-Host -ForegroundColor magenta "    already exist"
		}
	}
}

if ($importtogroups -ne "")
{
	Write-Host -ForegroundColor green "Importing users from $importtogroups";
	ipcsv $importtogroups | foreach { 
		$user = $_.User
		$group = $_.Group
		Write-Host -ForegroundColor green "  $user -> $group"
		# Add user to the web
    try{
		$spuser = $web.EnsureUser($user);
}
catch
{
$logstring = "Unable to Add User" + "- " + $spuser
LogFile ($logstring)
}
		# Add user to group
		if ($group -ne "") 
		{
			Set-SPUser -Identity $spuser -Web $web -Group $group
		}
	}
}

if ($importwithperm -ne "") 
{
	Write-Host -ForegroundColor green "Importing ad groups from $importwithperm";
	ipcsv $importwithperm | foreach { 
		$group = $_.GroupName;
		$perm = $_.Permissions;
		
		Write-Host -ForegroundColor green "  $group (perm = $perm)"
		$sp = $web.EnsureUser($group);

		# Give permissions to the group
		$assign = New-Object Microsoft.SharePoint.SPRoleAssignment($sp);
		$assign.RoleDefinitionBindings.Add($web.RoleDefinitions[$perm])
		$web.RoleAssignments.Add($assign)
	}
}

$site.Dispose();
Write-Host -ForegroundColor green "Done.";
