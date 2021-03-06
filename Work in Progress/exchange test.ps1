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

#############################################################################################################################################


# Prompt for user
$Username = Read-Host -Prompt "Input the UserName"

# Find user associated with entry
$User = Get-Aduser $Username -Properties sAMAccountName, displayName, mail, manager

# Ask if user found/selected is correct
$Message  = 'User - ' + $User.DisplayName 
$Question = 'Is ' + $User.DisplayName + ' the correct user?'
  
$Choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$Decision = $Host.UI.PromptForChoice($Message, $Question, $Choices, 0)

if ($Decision -eq 0) {
  
  $manager = Get-ADuser $User.manager -Properties emailaddress
  
  # Set Mailbox settings
  Set-Mailbox -Identity $User.DistinguishedName -IgnoreDefaultScope -HiddenFromAddressListsEnabled $true -ForwardingSmtpAddress $manager.emailaddress -DeliverToMailboxAndForward $true -Verbose
  
}

Remove-PSSession $Session
