if (Get-Command Get-Mailbox -ErrorAction 'silentlycontinue'){}
else {
#Open remote session and import all Exchange cmdlets
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://sanexmbdb02.icwgrp.com/PowerShell/ -Authentication Kerberos
Import-PSSession $Session
}

$Users = Import-csv "C:\users\apolanco\desktop\wcc Users.csv"


$SafeEmail = "SQLAdmin@DC1WCCSQLPRD02.ICWGROUP.COM"

Foreach ($User in $Users) {
  
  
  if($User.emailAddress -like "*@icwgroup.com") {
  
    $Username = $User.samAccountName
    $Email = $User.emailaddress
      
    $DNames = Get-Mailbox -Anr $Username -IgnoreDefaultScope | select -ExpandProperty distinguishedname
    
    foreach ($Dname in $Dnames ) {
      Try{
        if(!($Dname -eq $Null)) {
          Set-MailboxJunkEmailConfiguration -Identity $DName -IgnoreDefaultScope -TrustedSendersAndDomains @{Add=$SafeEmail}
          "`r`n`r`nAdded $SafeEmail to $Username's safe senders list`r`n`r`n" 
        }
      }
      Catch{
        "`r`n`r`nERROR: Unable to add $SafeEmail to $Username's safe senders list`r`n`r`n"
      }
    }
  }
  $Username = $NULL
}

Remove-PSSession $Session