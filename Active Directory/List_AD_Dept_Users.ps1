# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Path = "$env:userprofile\desktop"

$Dept = Read-Host "Dept"

Get-ADUser -Filter {(Enabled -eq $True)} -Properties DisplayName, Department, Emailaddress |
Where { $_.Department -like "$Dept*" } |
Select DisplayName, samAccountName, EmailAddress |
Sort DisplayName |
Export-CSV "$Path\$Dept Users.csv" -notype