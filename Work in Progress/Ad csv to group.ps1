# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}


$Salesusers = Import-CSV "C:\users\apolanco\desktop\SalesUsers.csv"

Foreach ($SUser in $SalesUsers) {
  $User = get-aduser -Filter { Enabled -eq $TRUE} -Properties emailaddress, displayname |
  Where { $_.emailaddress -eq $SUser.Username } |
  Select displayname
  
}