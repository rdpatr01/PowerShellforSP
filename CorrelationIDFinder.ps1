Add-PSSnapin Microsoft.sharepoint.powershell
$CorrelationID = "eefc769d-f54d-00c9-03b7-df748272c170";
$Path = ""
$a = Get-Date -UFormat "%Y%m%d-%H%M"
$FileName = $a + ".txt"
$FQN = $Path + $FileName

Merge-SPLogFile -Path $FQN -Correlation $CorrelationID -Overwrite

#Merge-SPLogFile -Path $FQN -StartTime "01/18/2016 09:00" -EndTime "01/18/2016 09:35" -Overwrite


