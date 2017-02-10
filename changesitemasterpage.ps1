#Add SP References
Add-PSSnapin Microsoft.sharepoint.powershell
# get web object of the site
$web = get-spweb "Site URL Here" 
#Sample "/sites/spTeamRestore/_catalogs/masterpage/v4.master"-------This sets the masterpage
$web.MasterUrl = "Relative URL"  
#Sample "/sites/spTeamRestore/_catalogs/masterpage/v4.master" -----------This sets the system masterpage
$web.CustomMasterUrl = "Relative Url"  
#Update the changes
$web.Update()   