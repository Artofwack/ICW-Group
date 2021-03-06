# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$List = @()

$Users = Import-Csv "c:\Users\apolanco\desktop\PowerBIUsers.csv" 


Foreach ($User in $Users) { 
  $List += Get-ADUser -Filter {Enabled -eq 'True'} -Properties DisplayName, UserPrincipalName |
  Where {$_.DisplayName -like $User.DisplayName} |
  Select DisplayName, UserprincipalName
  
}

 
$List | Export-csv "c:\users\apolanco\desktop\out.csv" -notype 
