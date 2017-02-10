#Load dll’s
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client") | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime") | Out-Null


Function Get-SPOContext([string]$Url,[string]$UserName,[string]$Password)
{
    $SecurePassword = $Password | ConvertTo-SecureString -AsPlainText -Force
    $context = New-Object Microsoft.SharePoint.Client.ClientContext($Url)
    $context.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName, $SecurePassword)
    return $context
}

Function Get-ListItems([Microsoft.SharePoint.Client.ClientContext]$Context, [String]$ListTitle) {
    $list = $Context.Web.Lists.GetByTitle($listTitle)
    $qry = [Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery()
    $items = $list.GetItems($qry)
    $Context.Load($items)
    $Context.ExecuteQuery()
    return $items 
}



$UserName = "rpatrick@composabledev.onmicrosoft.com"
$Password = Get-Content D:\pas.txt 
$Url = "https://composabledev.sharepoint.com/sites/dev"


$context = Get-SPOContext -Url $Url -UserName $UserName -Password $Password
$items = Get-ListItems -Context $context -ListTitle "StockPrice" 
foreach($item in $items)
{
  $ticker = $item["Ticker"];
   $url = "dev.markitondemand.com/Api/v2/Quote?symbol=$ticker"
   $result = Invoke-RestMethod $url
   if($result.DocumentElement.Status -eq 'Success')
   {
       $Ask = $result.DocumentElement.LastPrice
       $change = $result.DocumentElement.Change
       $item["Price"] = $Ask
       $item["Change"] = $change
       $item.Update()
   }

}
$context.ExecuteQuery()
$context.Dispose()