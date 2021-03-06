if (Get-Command Get-Mailbox -ErrorAction 'silentlycontinue'){}
else {
#Open remote session and import all Exchange cmdlets
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sanexmbdb02.icwgrp.com/PowerShell/ -Authentication Kerberos
Import-PSSession $Session
}

$Users = Import-csv "$env:userprofile\desktop\NONWCCUsers.csv"


$BlockedDomain = "medicallienmgt.com"

Foreach ($User in $Users) {
  
  
  if($User.emailAddress -like "*@icwgroup.com") {
  
    $Username = $User.samAccountName
    $Email = $User.emailaddress
      
    $DNames = Get-Mailbox -Anr $Username -IgnoreDefaultScope | select -ExpandProperty distinguishedname
    #($DName = Get-Mailbox -Filter {userprincipalname -eq $email} -IgnoreDefaultScope | select -ExpandProperty distinguishedname)
    
    foreach ($Dname in $Dnames ) {
      Try{
        if(!($Dname -eq $Null)) {
          Set-MailboxJunkEmailConfiguration -Identity $DName -IgnoreDefaultScope -BlockedSendersAndDomains @{Add=$BlockedDomain} -verbose        
          "`r`n`r`nAdded $SafeEmail to $Username's safe senders list`r`n`r`n" >> "\\sancfs001\public$\apolanco\scripts\Email\safe.txt"
        }
      }
      Catch{
        "`r`n`r`nERROR: Unable to add $SafeEmail to $Username's safe senders list`r`n`r`n" >> "\\sancfs001\public$\apolanco\scripts\Email\safe.txt"
      }
    }
  }
  $Username = $NULL
}

Exit-PSSession $Session