[string]$logFile = $null

function CreateLogFile {
	Param ([string]$path)
    $pathBool = Test-Path $path
try
{
    if(!$pathBool)
    {
      md $path
    }
}
catch
{
    Write-Host "Unable to Create File Path!"
    Break
}
    $currentDateTime = Get-Date -UFormat "%Y%m%d-%H%M"

    $fileName ="\"+ $currentDateTime + ".txt"
    $script:logFile = $path + $fileName  
    Write-Host $script:logFile

}

function LogFile {
	Param (
[string]$logString,
[ValidateSet('Debug','Error','Information','Trace','Warning')]
[System.String]$loggingType,
[DateTime] $timeStamp
)
    $timeStamp=([System.DateTime]::Now)
    $logMessage = "["+$LoggingType+"]"+"::"+"["+$timeStamp+"]"+"::"+$logString
	Add-content $script:Logfile -value $logMessage
}