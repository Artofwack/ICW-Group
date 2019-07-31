# Import-Module ActiveDirectory
if( Get-Command Get-ADUser -ErrorAction 'silentlycontinue'){}
else {
  Import-Module ActiveDirectory
}
import-csv C:\it\Adduser.csv | % { add-adgroupmember -Server ICWPDC-SD.ICWGRP.COM -identity "SG-Okta-Atlassian" -member $_.samaccountname }
