# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}


$Accounts = Import-Csv "c:\Users\apolanco\desktop\Title change.csv"

foreach ($Account in $Accounts){
  Try {
    Set-ADUser $Account.samAccountName -title $Account.title
  } Catch {
    "Unable to set " + $Account.displayname >> "C:\Users\apolanco\Desktop\Title_log.txt"
  }  
}  
 