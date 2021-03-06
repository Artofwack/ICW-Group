# Enable Existing AD User
# Arturo E Polanco
# 10-26-18

#
# Enables User in AD 
#
###########################################################################
#
# Adds User to all groups except 'Domain users'
#
# Sets AD User Object settings to Enabled
#
# Imports Manager info from csv and sets manager field for user
#
# Enables account in AD 
# 
############################################################################

# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

# Validate Exchange commands exist or import if needed
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
$User = Get-Aduser $Username -Properties sAMAccountName, Country, city, postalCode, st, streetAddress, description, displayName,
givenName, mail, physicalDeliveryOfficeName, telephoneNumber, whenChanged, whenCreated, department, directReports, manager, title,
mobile, employeeID, msRTCSIP-PrimaryUserAddress, msRTCSIP-PrimaryHomeServer, msRTCSIP-UserEnabled, AccountExpirationDate

# Ask if user found/selected is correct
$Message  = 'User - ' + $User.DisplayName 
$Question = 'Is ' + $User.DisplayName + ' the correct user?'
  
$Choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$Decision = $Host.UI.PromptForChoice($Message, $Question, $Choices, 0)

if ($Decision -eq 0) {

# Set path variable for logs and resource files
$Path = "\\sancfs001\public$\apolanco\Scripts\Work in Progress"

#############################################################################################################################################
 
# Add Group Membership
 
  Try {
    $ADgroups = Import-CSV $Path\Groups.csv
    "Imported Groups" >> "$Path\$Username - Log.txt"
  }
  
  Catch {
    "Could not import CSV" >> "$Path\$Username - Log.txt"
  }
  
  Try {
    Foreach ($Group in $ADGroups ) {
      # Add user to AD Group Object
      Add-ADPrincipalGroupMembership $User -Memberof $Group
      "Added user to $Group" >> "$Path\$Username - Log.txt"
    }    
  }
  
  Catch {
    "Could not add user to $Group" >> "$Path\$Username - Log.txt"
  }
  
  

#############################################################################################################################################
  
  
  # Set User setting variables to enabled
  [byte[]]$logonhours = @(255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255)
  
  
    
  # Set Description string
  if ($User.Description -eq $null){
    $User.Description = "Enabled $(Get-Date -UFormat %m/%d/%y) APscript"
  }
  else{
    $User.Description = $User.Description + " Enabled $(Get-Date -UFormat %m/%d/%y) APscript"
  }
    
    
  # Account settings to replace
  $replaceHashTable = New-Object HashTable  
  $replaceHashTable.Add("logonHours", $logonhours)
  
  $Sip = "sip:"+$User.samaccountname+"@icwgroup.com"

  # Hash Table of AD settings to edit
  $replaceCommHashTable = New-Object HashTable

  $replaceCommHashTable.Add("msRTCSIP-PrimaryUserAddress",$Sip) # Set sip address with UPN
  $replaceCommHashTable.Add("msRTCSIP-ArchivingEnabled","0")
  $replaceCommHashTable.Add("msRTCSIP-OptionFlags","256")
  $replaceCommHashTable.Add("msRTCSIP-PrimaryHomeServer", "CN=LC Services,CN=Microsoft,CN=sanocspl01,CN=Pools,CN=RTC Service,CN=Microsoft,CN=System,DC=ICWGRP,DC=com") # Set ICW Server pool
  $replaceCommHashTable.Add("msRTCSIP-UserEnabled", $True) # Enable Communicator
        
  #############################################################################################################################################  
  
  # Set Logon Hours
  
  Try {
    Set-ADUser $User.SamAccountName -Replace $replaceHashTable
      
    "Set Logon Hours account settings" >> "$Path\$Username - Log.txt"        
  }
  
  Catch {
    "Unable to set Logon Hours" >> "$Path\$Username - Log.txt"
  }

  #############################################################################################################################################  
  
  # Set Expiration Date
  
  Try{
    Clear-ADAccountExpiration $User.SamAccountName
    
    "Set Expiration Date to 'Never'" >> "$Path\$Username - Log.txt"
  }
  
  Catch{
    "Unable to disable Expiration Date" >> "$Path\$Username - Log.txt"
  }
  
  #############################################################################################################################################  
  
  # Set Description
  
  Try{
    Set-ADUser $User.SamAccountName -Description $User.Description
    "Updated Description" >> "$Path\$Username - Log.txt"
  }
  
  Catch{
    "Unable to disable Description" >> "$Path\$Username - Log.txt"
  }
  
#############################################################################################################################################

  # Add Manager
  
  Try{
    $Man = Import-csv $Path\properties.csv
    $manager = $Man.Manager
 
    Set-ADUser $User.SamAccountName -Manager $manager
    "Added Manager" >> "$Path\$Username - Log.txt"
  }
  
  Catch{
    "Unable to add Manager" >> "$Path\$Username - Log.txt"
  }
  
  #############################################################################################################################################  
  
  # Enable Communicator
  
  Try{
    Set-ADUser $User.SamAccountName -Replace $replaceCommHashTable -Confirm:$false
    "Enabled Communicator" >> "$Path\$Username - Log.txt"
  }
  
  Catch {
    "Unable to enable Communicator" >> "$Path\$Username - Log.txt"
  }

  #############################################################################################################################################
  
  # Enable Account
  
  Try{
    $User.SamAccountName | Enable-ADAccount 
    
    "Enabled account" >> "$Path\$Username - Log.txt"
  }
  
  Catch{
    "Unable to enable account" >> "$Path\$Username - Log.txt"
  }

}  
 