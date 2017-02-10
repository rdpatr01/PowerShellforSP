# Load the SharePoint assembly - change the version to 15.0.0.0 for SharePoint 2013
Add-PSSnapin MIcrosoft.Sharepoint.Powershell
 
# Reset the content index
(Get-SPEnterpriseSearchServiceApplication).Reset($true,$true)
 
# Get the database server for the default content service
$dbServer = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.DefaultDatabaseInstance.NormalizedDataSource
 
# Get the SQL Management Object server for the content service retrieved above
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
$SMOserver = New-Object ('Microsoft.SqlServer.Management.Smo.Server') -argumentlist $dbServer
 
# Get the search service application instance
$searchServiceApp = (Get-SPEnterpriseSearchServiceApplication)
 
# Iterate the crawl stores and for each database, shrink it in size by 20%
foreach($crawlStore in $searchServiceApp.CrawlStores)
{		
	$dbName = $crawlStore.Name	
	$db = $SMOserver.Databases[$dbName]
	if ($db -ne $null)  
	 {  
		$db.Shrink(20, [Microsoft.SqlServer.Management.Smo.ShrinkMethod]'TruncateOnly')
		Write-Host "$dbName has been shrunk"
	 }
	 else
	 {
		Write-Host "$dbName does not exist"
	 }
}