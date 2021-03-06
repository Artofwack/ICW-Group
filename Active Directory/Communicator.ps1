# Activate Communicator for AD Users
# Arturo E Polanco
# 8-8-18


###########################################################################
#
#  Enables communicator in AD for existing User
# 
# 
############################################################################


# Validate Active Directory commands exist
if (Get-Command Get-ADUser -ErrorAction 'silentlycontinue'){}
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

$Username = Read-Host -Prompt "Input the Username"

$user = Get-ADUser $Username -Properties msRTCSIP-PrimaryUserAddress, msRTCSIP-PrimaryHomeServer, msRTCSIP-UserEnabled, samaccountname, emailaddress, UserPrincipalName

$Sip = "sip:"+$User.UserPrincipalName

# Hash Table of AD settings to edit
$replaceHashTable = New-Object HashTable

$replaceHashTable.Add("msRTCSIP-PrimaryUserAddress",$Sip) # Set sip address with UPN
$replaceHashTable.Add("msRTCSIP-ArchivingEnabled","0")
$replaceHashTable.Add("msRTCSIP-OptionFlags","256")
$replaceHashTable.Add("msRTCSIP-PrimaryHomeServer", "CN=LC Services,CN=Microsoft,CN=sanocspl01,CN=Pools,CN=RTC Service,CN=Microsoft,CN=System,DC=ICWGRP,DC=com") # Set ICW Server pool
$replaceHashTable.Add("msRTCSIP-UserEnabled", $True) # Enable Communicator


Try{
  Set-ADUser $User.SamAccountName -Replace $replaceHashTable -Confirm:$false
}
Catch {
  
}
