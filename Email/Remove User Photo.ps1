# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

# Validate Exchange commands exist
if (Get-Command Get-Mailbox -ErrorAction 'silentlycontinue'){}
else {
#Open remote session and import all Exchange cmdlets
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sanexmbdb02.icwgrp.com/PowerShell/ -Authentication Kerberos
Import-PSSession $Session

}

$DName = Get-Mailbox -Anr "apolanco" -IgnoreDefaultScope | select -ExpandProperty distinguishedname

Set-Mailbox -identity $DName -IgnoreDefaultScope -RemovePicture
