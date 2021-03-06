# Validate Exchange commands exist
if (Get-Command Get-Mailbox -ErrorAction 'silentlycontinue'){}
else {
#Open remote session and import all Exchange cmdlets
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sanexmbdb02.icwgrp.com/PowerShell/ -Authentication Kerberos
Import-PSSession $Session

}

Get-Command new-transportrule

New-TransportRule -Name 'Allow wcreports' -Comments ' Flag internal wcreports email as not junk and set SCL to minus 1' -Priority '0' -Enabled $true -From 'wcreports@icwgroup.com' -SetSCL '-1' -whatif