# Set Mailbox Auto-Reply
# Arturo E Polanco
# 6-28-18

#
# Disables an Auto Reply Message for a user without needing to
# grant full access permissions to or remote in to mailbox.
#
# Mailboxes that are set up with an Auto Reply Message usually
# need the user to turn off the Auto Reply rule from Outlook
# or Webmail.
#

if (Get-Command Get-Mailbox -ErrorAction 'silentlycontinue'){}
else {
#Open remote session and import all Exchange cmdlets
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sanexmbdb02.icwgrp.com/PowerShell/ -Authentication Kerberos
Import-PSSession $Session
}

#if( Get-Command Get-ADUser -ErrorAction 'silentlycontinue'){}
#else {
#  Import-Module ActiveDirectory
#}

# Prompt for user
  $Username = Read-Host -Prompt "Input the User"

  # Find user associated with entry
  $User = Get-Mailbox -Anr $Username -IgnoreDefaultScope | Select -ExpandProperty Name

# TODO: Validate single user found/selected - may need to give option to select from list of matches

  # Ask if user found/selected is correct
  $Message  = 'User - ' + $User 
  $Question = 'Is ' + $User + ' the correct user?'
  
  $Choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
  $Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
  $Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))
  $Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Cancel'))
  
  $Decision = $Host.UI.PromptForChoice($Message, $Question, $Choices, 0)
  if ($Decision -eq 0) {
        
    # Assign user's mailbox distinguished name to $dname for mailbox configuration
    $DName = Get-Mailbox -Anr "$Username" -IgnoreDefaultScope | select -ExpandProperty distinguishedname
        
    # Apply all configurations ignoreDefaultScope allows searching across domains
    Set-MailboxAutoReplyConfiguration -Identity "$DName" -IgnoreDefaultScope -AutoReplyState Disabled
    
    #$email = Get-ADuser -Identity $DName -Properties * | Select emailaddress
    
      
  }