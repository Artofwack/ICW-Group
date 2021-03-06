# Add Email to Safe Sender List
# Arturo E Polanco
# 12-18-18

#
# Adds an email to user's Safe Senders List
# 
# User's mailbox is found using AD username
# 
# Email to be added to list needs to be in full email format
# 
#


if (Get-Command Get-Mailbox -ErrorAction 'silentlycontinue'){}
else {
#Open remote session and import all Exchange cmdlets
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sanexmbdb01.icwgrp.com/PowerShell/ -Authentication Kerberos
Import-PSSession $Session
}

$Username = Read-Host -Prompt "Enter Username"

$SafeEmail = Read-Host -Prompt "Enter the email to add to Safe Senders list"

$DName = Get-Mailbox -Anr $Username -IgnoreDefaultScope | select -ExpandProperty distinguishedname

Try{
  Set-MailboxJunkEmailConfiguration -Identity $DName -IgnoreDefaultScope -TrustedSendersAndDomains @{Add=$SafeEmail}
  "Added $SafeEmail to $Username's safe senders list" # >> "\\sancfs001\public$\apolanco\scripts\Email\safe.txt"
}
Catch{
  "ERROR: Unable to add $SafeEmail to $Username's safe senders list" # >> "\\sancfs001\public$\apolanco\scripts\Email\safe.txt"
}