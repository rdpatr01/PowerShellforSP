#requires -version 2
<#
.SYNOPSIS
  This script uninstalls, then installs the LKE Design package

.DESCRIPTION
  This script uninstalls, then installs the LKE Design package

.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>

.INPUTS
  <Inputs if any, otherwise state None>

.OUTPUTS
  Logs to D:\Logs\FarmUpload

.NOTES
  Version:        1.0
  Author:         Russell Patrick
  Creation Date:  04/08/15
  Purpose/Change: Initial script development
  
#>
 
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Load Modules
Import-Module Logging -Force
Import-Module Email -Force

#Add SharePoint Snapin
Add-PSSnapin Microsoft.SharePoint.Powershell
 
#----------------------------------------------------------[Declarations]----------------------------------------------------------
 
#Script Version = "1.0"
 
 #Save the current value in the $p variable.
$p = [Environment]::GetEnvironmentVariable("PSModulePath")

#Add the new path to the $p variable. Begin with a semi-colon separator.
$p += ";D:\Russell'sScripts\Modules\"

#Add the paths in $p to the PSModulePath value.
[Environment]::SetEnvironmentVariable("PSModulePath",$p)

#Log File Info
$Path = "D:\Logs\FarmUpload\"
CreateLogFile -Path $Path

 
#-----------------------------------------------------------[Functions]------------------------------------------------------------
 
 #None
 
#-----------------------------------------------------------[Execution]------------------------------------------------------------

 Logfile ((get-date).toString()+ "-"  + "Start of Farm Upload Script")
 Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")


#First Uninstall the Old Design Package
try{
Uninstall-SPSolution -Identity  -Confirm:$false
}
#Will Probably fail here as we dont assign a language pack to the wsp
catch [Exception]  #log errors to log file
{
Logfile ((get-date).toString()+ "-"  + "Failed to Uninstall Solution")  
          Logfile ((get-date).toString()+ "-" + $_.Exception.GetType().FullName + "-"  + $_.Exception.Message)
          Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")
}
#Remove the solution package from the farm
try{
Remove-SPSolution -Identity  -Confirm:$false

}
catch [Exception]  #log errors to log file
{
Logfile ((get-date).toString()+ "-"  + "Failed to Remove Solution")  
          Logfile ((get-date).toString()+ "-" + $_.Exception.GetType().FullName + "-"  + $_.Exception.Message)
          Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")
}
#add our new package from our local location
try{
Add-SPSolution -LiteralPath "" -Confirm:$false

}
catch [Exception]  #log errors to log file
{
Logfile ((get-date).toString()+ "-"  + "Failed to Add Solution")  
          Logfile ((get-date).toString()+ "-" + $_.Exception.GetType().FullName + "-"  + $_.Exception.Message)
          Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")
}
#install solution package to all web apps, and to the GAC
try{
Install-SPSolution -Identity  -GACDeployment -Force -Confirm:$false
}
catch [Exception] #log errors to log file
{
Logfile ((get-date).toString()+ "-"  + "Failed to Install Solution")  
          Logfile ((get-date).toString()+ "-" + $_.Exception.GetType().FullName + "-"  + $_.Exception.Message)
          Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")
}

 Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")
 Logfile ((get-date).toString()+ "-"  + "End of Farm Upload Script")

 #First Uninstall the Old Design Package
try{
Uninstall-SPSolution -Identity  -Confirm:$false
}
#Will Probably fail here as we dont assign a language pack to the wsp
catch [Exception]  #log errors to log file
{
Logfile ((get-date).toString()+ "-"  + "Failed to Uninstall Solution")  
          Logfile ((get-date).toString()+ "-" + $_.Exception.GetType().FullName + "-"  + $_.Exception.Message)
          Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")
}
#Remove the solution package from the farm
try{
Remove-SPSolution -Identity  -Confirm:$false

}
catch [Exception]  #log errors to log file
{
Logfile ((get-date).toString()+ "-"  + "Failed to Remove Solution")  
          Logfile ((get-date).toString()+ "-" + $_.Exception.GetType().FullName + "-"  + $_.Exception.Message)
          Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")
}
#add our new package from our local location
try{
Add-SPSolution -LiteralPath "" -Confirm:$false

}
catch [Exception]  #log errors to log file
{
Logfile ((get-date).toString()+ "-"  + "Failed to Add Solution")  
          Logfile ((get-date).toString()+ "-" + $_.Exception.GetType().FullName + "-"  + $_.Exception.Message)
          Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")
}
#install solution package to all web apps, and to the GAC
try{
Install-SPSolution -Identity  -GACDeployment -Force -Confirm:$false
}
catch [Exception] #log errors to log file
{
Logfile ((get-date).toString()+ "-"  + "Failed to Install Solution")  
          Logfile ((get-date).toString()+ "-" + $_.Exception.GetType().FullName + "-"  + $_.Exception.Message)
          Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")
}

 Logfile ((get-date).toString()+ "-"  + "-------------------------------------------------------------------")
 Logfile ((get-date).toString()+ "-"  + "End of Farm Upload Script")

