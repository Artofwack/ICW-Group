# Term Users
# Arturo E Polanco
# 7-27-18

#
# Disables a Single User in AD per ICW Policy
#
###########################################################################
#
# Creates a Folder based on the username and exports properties and group membership list each to a csv file within the folder.
#
# Disables the user's Exchange Mailbox, Forwards Emails to Manager or provides Full Access for manager to mailbox
#
# Removes User from all groups except 'Domain users'
#
# Moves AD User Object to 'Termed Users' OU
#
# Sets AD User Object settings to Disabled status per ICW policy
#  
############################################################################


$Path = "//SANCFSINO1/DATA/CSS/DOCS/SEPARATIONS/$(GET-DATE -UFormat %Y)" 

$termFile = "IT Security-User Separation Checklist v8.docx"


############################################################################


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

# Find Correct User to Term

# Prompt for user
$Username = Read-Host -Prompt "Input the UserName"

# Find user associated with entry
$User = Get-Aduser $Username -Properties EmployeeID, samAccountName, givenName, surName, displayName, mail, telephoneNumber, Description, whenChanged, Title, Department, manager, Company, Office, msRTCSIP-UserEnabled

# Ask if user found/selected is correct
$Message  = 'User - ' + $User.DisplayName 
$Question = 'Is ' + $User.DisplayName + ' the correct user?'
  
$Choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$Decision = $Host.UI.PromptForChoice($Message, $Question, $Choices, 0)

if ($Decision -eq 0) {
  

#############################################################################################################################################
#############################################################################################################################################

 
  Try {
    
    # Create Folder for User
    
    $UserFolder = $User.DisplayName
    # Create new folder if it doesn't exist, otherwise create sub-folder with timestamp
    if(!(Test-Path -Path "$Path/$UserFolder" )) {
      $Folder = New-Item "$Path/$UserFolder" -ItemType Directory
    }
    else {
      $Folder = New-Item "$Path/$UserFolder/$(get-date -f MM-dd_hh-mm)" -ItemType Directory
    }
    
    Copy-Item -Path "$Path\IT Security-User Separation Checklist v8.docx" -Destination "$Folder\$UserFolder.docx"
    
    # Capture users groups and properties for records
    
    # Get User Properties and export to csv file
    $User | Export-CSV "$Folder/Properties.csv" -notype
    
    # Get Group Membership for user and export to csv file
    $ADgroups = Get-ADPrincipalGroupMembership $User.SamAccountName
    $ADgroups | Select Name | Export-CSV "$Folder/Groups.csv" -notype
    
    "---- Created User Term Folder            `n" >> $Folder\log.txt
  }
  Catch {
    "---- Unable to Create Folder Path            `n" >> $Folder\log.txt
    Break
  }
 
  #############################################################################################################################################
  
  # Set Exchange Mailbox Settings
  
  Try {
    # Disable Exchange Mailbox
    Set-Mailbox -Identity $User.DistinguishedName -IgnoreDefaultScope -HiddenFromAddressListsEnabled $true
    
    "---- Disabled Mailbox            `n" >> $Folder/log.txt
  }  
  Catch {
    "---- Unable to Disable Mailbox            `n" >> $Folder/log.txt
  }
  
  # Ask if user found/selected is correct
  $EmailMessage  = 'User - ' + $User.DisplayName 
  $EmailQuestion = 'Email Forwarding or Full Mailbox Access?'  
  
  $EmailChoices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
  $EmailChoices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Forwarding'))
  $EmailChoices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Mailbox Access'))
  $EmailChoices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&None'))

  $EmailDecision = $Host.UI.PromptForChoice($EmailMessage, $EmailQuestion, $EmailChoices, 0)
  
  # Set Email Forwarding
  if ($EmailDecision -eq 0) {
    Try {
      $manager = Get-ADuser $User.manager -Properties emailaddress
    
      Set-Mailbox -Identity $User.DistinguishedName -IgnoreDefaultScope -ForwardingAddress $manager.emailaddress -DeliverToMailboxAndForward $true
    
      "---- Set Email Forwarding to Manager            `n" >> $Folder/log.txt
    }
    Catch {
      "---- Unable to set Email Forwarding            `n" >> $Folder/log.txt
    }
  }
  
  # Set Mailbox Full Access Permissions
  if ($EmailDecision -eq 1) {
    Try {
      $manager = Get-ADuser $User.manager -Properties emailaddress, distinguishedname
    
      Add-MailboxPermission -Identity $User.DistinguishedName -IgnoreDefaultScope -User $manager.DistinguishedName -AccessRights FullAccess -InheritanceType All
    
      "---- Set Full Access Permissions for manager            `n" >> $Folder/log.txt
    }
    Catch {
      "---- Unable to set Full Access Permissions for manager            `n" >> $Folder/log.txt
    }
  }
  
  # No Email Forwarding or Mailbox Access
  if ($EmailDecision -eq 2) {
    "---- No Email Forwarding or Mailbox Access requested            `n" >> $Folder/log.txt
  }
  
    
  #############################################################################################################################################  
  
  
  # Remove Group Membership
 
 Try {
    
    $ADgroups = $ADgroups | where {$_.Name -ne "Domain Users"}
    
    if ($ADgroups -ne $null){
      Remove-ADPrincipalGroupMembership $User.SamAccountName -MemberOf $ADgroups -Confirm:$false      
    }
    "---- Removed $UserFolder from $ADGroups            `n" >> $Folder/log.txt
  }
  Catch {
    "---- Unable to Remove $UserFolder from $ADGroups            `n" >> $Folder/log.txt
   
  }

  #############################################################################################################################################
  
  
  # Move to 'Termed Users' OU
  
  Try {
    $TermedOU = Get-ADObject -filter { Name -eq 'Termed Users' } | select -ExpandProperty distinguishedname
    
    Get-AdUser $User.SamAccountName | Move-ADObject -TargetPath $TermedOU
    "---- Moved $UserFolder to Termed Users OU            `n" >> $Folder/log.txt
   
  }
  Catch {
    "---- Removed $UserFolder from $ADGroups            `n" >> $Folder/log.txt
    
  }
  
  #############################################################################################################################################
  
  
  # Set User settings to disabled
  [byte[]]$logonhours = @(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
 
  $TermDate = $(Get-Date -uf "%D %R")
    
  # Set Description string
  $admin = [Security.Principal.WindowsIdentity]::GetCurrent()

  $SDMember = Get-ADUser -Identity $admin.user | Select -ExpandProperty samAccountName
  
  if ($User.Description -eq $null){
    $User.Description = "Termed $(Get-Date -UFormat %D) APscript by $SDMember"
  }
  else{
    $User.Description = $User.Description + " Termed $(Get-Date -UFormat %D) APscript by $SDMember"
  }
    
    
  # Account settings to replace
  $replaceHashTable = New-Object HashTable  
  $replaceHashTable.Add("logonHours", $logonhours)
  
  $CommHash = New-Object HashTable
  $CommHash.Add("msRTCSIP-UserEnabled", $False) # Disable Communicator
        
  #############################################################################################################################################  
  
  # Set Logon Hours
  
  Try {
    Set-ADUser $User.SamAccountName -Replace $replaceHashTable
      
    "---- Set Logon Hours account settings            `n" >> $Folder/log.txt        
  }
  
  Catch {
    "---- Unable to set Logon Hours            `n" >> $Folder/log.txt
  }

  #############################################################################################################################################  
  
  # Set Expiration Date
  
  Try{
    Set-ADUser $User.SamAccountName -AccountExpirationDate $TermDate
    
    "---- Set Expiration Date to $TermDate            `n" >> $Folder/log.txt
  }
  
  Catch{
    "---- Unable to disable Expiration Date            `n" >> $Folder/log.txt
  }
  
  #############################################################################################################################################  
  
  # Set Description
  
  Try{
    Set-ADUser $User.SamAccountName -Description $User.Description
    "---- Updated Description            `n" >> $Folder/log.txt
  }
  
  Catch{
    "---- Unable to disable Description            `n" >> $Folder/log.txt
  }
  
#############################################################################################################################################

  # Remove Manager
  
  Try{
    Set-ADUser $User.SamAccountName -Manager $null
    "---- Removed Manager            `n" >> $Folder/log.txt
  }
  
  Catch{
    "---- Unable to remove Manager            `n" >> $Folder/log.txt
  }
  
  #############################################################################################################################################  
  
  # Disable Communicator
  
  Try{
    Set-ADUser $User.SamAccountName -Replace $CommHash
    "---- Disabled Communicator            `n" >> $Folder/log.txt
  }
  
  Catch{
    "---- Unable to disable Communicator            `n" >> $Folder/log.txt
  }
  
  #############################################################################################################################################
  
  # Disable Account
  
  Try{
    $User.SamAccountName | Disable-ADAccount 
    
    "---- Disabled account            `n" >> $Folder/log.txt
  }
  
  Catch{
    "---- Unable to disable account            `n" >> $Folder/log.txt
  }

  #############################################################################################################################################
    
}
# Wrong user
else {
  
}

#Wait for keypress to exit
#Read-Host
