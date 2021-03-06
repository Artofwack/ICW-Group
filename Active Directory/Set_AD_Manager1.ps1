# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Man = Read-Host -Prompt "Enter Manager" 

$Manager = Get-ADUser -Filter { DisplayName -eq $Man } | Select -ExpandProperty DistinguishedName


$Users = Import-Csv "\\sancfs001\public$\apolanco\Scripts\Active Directory\Results\Athena McDonald Direct Reports.csv"

foreach ($User in $Users){
  $Use = Get-adUser $User.DistinguishedName -Properties Manager 
  
  if ($Use -ne $null -and $Use.Enabled -eq $true ) {
    Try{
      Set-adUser $Use.DistinguishedName -Manager $Manager
      "$Use.Displayname manager set to $Manager" >> "\\sancfs001\public$\apolanco\Scripts\Active Directory\Results\Log.txt"
    }
    Catch{
      "$Use.Displayname manager Not set" >> "\\sancfs001\public$\apolanco\Scripts\Active Directory\Results\Log.txt"
    }
  }
}
