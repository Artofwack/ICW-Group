# Set Mailbox Auto-Reply
# Arturo E Polanco
# 5-18-18

#
# Sets an Auto Reply Message for a user without needing to
# grant full access permissions to or remote in to mailbox.
#
# Mailboxes that are set up with an Auto Reply Message will
# need the user to turn off the Auto Reply rule from Outlook
# or Webmail.
#

# Validate Exchange commands exist
if (Get-Command Get-Mailbox -ErrorAction 'silentlycontinue'){}
else {
#Open remote session and import all Exchange cmdlets
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sanexmbdb02.icwgrp.com/PowerShell/ -Authentication Kerberos
Import-PSSession $Session

}

$File = "\\sancfs001\Clientserv$\Service Desk\Scripts\Email\OOOMessage.txt"


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
  
$Decision = 2
$Decision = $Host.UI.PromptForChoice($Message, $Question, $Choices, 0)
if ($Decision -eq 0) {
    
  # Assign user's mailbox distinguished name to $dname for mailbox configuration
  $DName = Get-Mailbox -Anr "$Username" -IgnoreDefaultScope | select -ExpandProperty distinguishedname
  
  # Prompt for Message(s)
  $note = Start-Process 'notepad.exe' $File -PassThru
  
  Wait-Process -Id $note.id
  
  if(!(get-process -id $note.id -ea 'silentlycontinue')) {  
    $Message = "<html><body>" + [IO.File]::ReadAllText($file) -replace "`n", "<br>"
    $Message += "</html></body>"
    
        
    # Apply all configurations
    Set-MailboxAutoReplyConfiguration $DName -AutoReplyState Enabled -IgnoreDefaultScope -InternalMessage $Message -ExternalMessage $Message
    
    # Reset txt file
    Set-Content $File -Value "Replace this text with the Out Of Office Message, close the notepad application and make sure to select SAVE."
  }
      
} else {
  # Loop to user prompt if not the correct user otherwise break
  break
} 

Remove-PSSession $Session
