# List PowerBI PRO Users
# Arturo E Polanco
# 3-06-19

#
# Lists all users in the PowerBI Pro Users Active Directory Group. This
# searches subgroups recursively and lists user objects only.
# 

# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Path = "$env:userprofile\desktop" #"\\sancfs001\public$\apolanco\Scripts\Active Directory\Results"

Get-adGroup -filter {Name -eq "DG-PowerBI Pro Users" } -Server "ICWGRP.COM" |  
Get-ADGroupMember -Recursive |
Where { $_.objectclass -eq 'user' } |
Select -ExpandProperty DistinguishedName |
Get-ADUser -Properties Displayname, EmailAddress, Department, Title, Company, Manager, userPrincipalName | 
Select DisplayName, userPrincipalName, Department, `
@{Name=”Manager”; Expression={$(get-aduser -identity $_.Manager -Properties DisplayName |
Select -ExpandProperty DisplayName)}} |
Sort Department, Manager, DisplayName |
Export-csv "$Path\PowerBI Pro.csv" -notype

<#$PSEmailServer = 'casarray1.icwgrp.com'
Send-MailMessage -From "Service Desk <servicedesk@icwgroup.com>" -To "apolanco <apolanco@icwgroup.com>" -Subject 'Sending the Attachment'
#>