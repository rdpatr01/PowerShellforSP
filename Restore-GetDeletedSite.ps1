
#Load dll’s
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime") | Out-Null


#Connect to SPO
Connect-SPOService -Url 'https://composabledev-admin.sharepoint.com'

#Delete Site

#Get Deleted Sites
Get-SPODeletedSite | Select Url, siteId
#Restore Specific Site (takes a while)
Restore-SPODeletedSite -Identity "https://composabledev.sharepoint.com/sites/Test Site"
