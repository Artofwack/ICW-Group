# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Users = Import-Csv "$env:userprofile\Desktop\Admin.csv"

$List = @()

foreach ($User in $Users){
  
  Try{
    $List += Get-adUser $User.user -Properties DisplayName, samAccountName, Manager |
    select Name, samaccountname, @{Name=”Manager”; Expression={$(get-aduser $_.Manager -Properties DisplayName | Select -ExpandProperty DisplayName)}}
        
  }
  Catch{
    $List += Get-adUser -Filter { EmailAddress -like "$($User.user)" } -Properties DisplayName, samAccountName, Manager |
    select Name, samaccountname, @{Name=”Manager”; Expression={$(get-aduser $_.Manager -Properties DisplayName | Select -ExpandProperty DisplayName)}}
  }   
}

$List | Export-csv "$env:userprofile\Desktop\Admin_manager.csv" -notype