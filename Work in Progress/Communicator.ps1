

if (Get-Command Get-Mailbox -ErrorAction 'silentlycontinue'){}
else {
#Open remote session and import all Exchange cmdlets
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sanexmbdb02.icwgrp.com/PowerShell/ -Authentication Kerberos
Import-PSSession $Session
}

$user = get-aduser pspidey


    
$replaceHashTable = New-Object HashTable

#$replaceHashTable.Add("msRTCSIP-PrimaryUserAddress","sip:pspidey@icwgroup.com")
#$replaceHashTable.Add("msRTCSIP-PrimaryHomeServer", "CN=LC Services,CN=Microsoft,CN=sanocspl01,CN=Pools,CN=RTC Service,CN=Microsoft,CN=System,DC=ICWGRP,DC=com")

$replaceHashTable.Add("msRTCSIP-UserEnabled", $True) # Disable Communicator
    
    
Set-ADUser $User.SamAccountName -Replace $replaceHashTable -Confirm:$false
   
