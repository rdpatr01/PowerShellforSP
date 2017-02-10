# #############################################################################
# 
# NAME: ICSCreation.ps1
# 
# AUTHOR:  Russell Patrick
# DATE:  2015/11/12
# EMAIL: rdpatr01@gmail.com
# 
# COMMENT:  This Script generates a new ICS file 
#
# VERSION HISTORY
# 1.0 2015.12.10 Initial Version.
# 
#
#
# 
# #############################################################################


#--- CONFIG ---#
#region Configuration
 # Script Path/Directories
 #Save the current value in the $p variable.
$p = [Environment]::GetEnvironmentVariable("PSModulePath")

#Add the new path to the $p variable. Begin with a semi-colon separator.
$p += ";D:\Russell'sScripts\Modules\"

#Add the paths in $p to the PSModulePath value.
[Environment]::SetEnvironmentVariable("PSModulePath",$p)

#Web Address
$web = ""


#--- MODULE/SNAPIN/DOT SOURCING/REQUIREMENTS ---#
Add-pssnapin Microsoft.SharePoint.Powershell

#region Module/Snapin/Dot Sourcing
  Import-Module Logging -Force
#end region Module/Snapin/Dot Sourcing

#Create Log File in the Path Below
CreateLogFile -Path "D:\Logs\ICSGen\"
#--- HELP ---#
#region help

<#
.SYNOPSIS
Processing Photos for AD
.DESCRIPTION
Processing of Photos for AD to keep quality and to resize
#>
#end region help

#--- FUNCTIONS ---#
#region functions
#This function create
function CreateICS()
{
Param ([string] $w)
#Get the web in question
$web = Get-SPWeb $w

$list = $web.Lists[""]
#Get all List Items
$items = $list.GetItems()
LogFile("Checking for New Items")
#Here we generate the header for the ICS file
$header = "<div style='width: 50%; float: left;'> <span style='font-weight: 700; font-size: 24px;'>Invite</span><br/></span></div><hr color='green' size='2' width='100%'/>"
#Here we generate the footer for the ICS file
$footer = "<hr color='green' size='2' width='100%'/>"
#Go through each item in the above list
foreach ($item in $items)
{
#if ICSGen Column is checked then create new
if($item["ICSGEN"] -eq $True)
{
#grab information for the ICS
LogFile("Creating ICS")
$id = $item["ID"]
$DTSTAMP = $item["Created"]
$DTSTART = $item["Start Date"].ToString("s")
$DTSTOP = $item["End Date"].ToString("s")
$Sum = $item["Title"]
$Descrip = $header + $item["Description"]+ $footer
$Loc = $item["Location"]
#Here we generate the ICS file
$file = "BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//hacksw/handcal//NONSGML v1.0//EN
BEGIN:VEVENT" +"
UID:sharepoint.support@lge-ku.com
DTSTAMP:" +$DTSTAMP+"
ORGANIZER;CN=SharePoint Support:MAILTO:sharepoint.support@lge-ku.com
DTSTART:" +$DTSTART+"
DTEND: "+$DTSTOP+"
SUMMARY: "+$Sum+"
Description;FMTTYPE=text/html:"+$Descrip+"
X-ALT-DESC;FMTTYPE=text/html:"+$Descrip+"
LOCATION: "+$Loc+"
END:VEVENT
END:VCALENDAR"


#filepath to the ICS storage location

$filePath = "C:\TrainingICS\"+$id+".ics"


$file | Out-File -FilePath $filePath

$bytes = [System.IO.File]::ReadAllBytes($filePath)

#Try to upload ics
try
{

$item.Attachments.Add([System.IO.Path]::GetFileName($filePath), $bytes)
}
#if exists then delete and reupload
catch
{
LogFile("ICS found. Deleteing and reuploading new")
    $file =$id.ToString()+".ics"
    $item.Attachments.Delete($file)
    $item.Attachments.Add([System.IO.Path]::GetFileName($filePath), $bytes)
}

$item["ICSGEN"] = $False
LogFile("Created ICS")
$item.Update()
}
}
}


#end region functions

#--- SCRIPT ---#
#region script
#call function with the web parameter
CreateICS -w $web


#end region script

