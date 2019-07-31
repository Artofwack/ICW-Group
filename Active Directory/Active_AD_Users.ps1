# Active AD Users
# Arturo E Polanco
# 10-29-18

#
# Returns list of AD user accounts that are currently active
#
###########################################################################
#
#
# 
#
# 
############################################################################


# Import-Module ActiveDirectory
if( Get-Command Get-ADUser -ErrorAction 'silentlycontinue'){}
else {
  Import-Module ActiveDirectory
}

$Path = "$env:userprofile\desktop" # "\\sancfs001\public$\apolanco\scripts\Active Directory\Results"

Get-ADUser -Property DisplayName, GivenName, Surname, Title, Department, Office, Company, TelephoneNumber,`
Samaccountname, EmailAddress, Manager, EmployeeID, MobilePhone -Filter { Enabled -eq $True -and PasswordNeverExpires -eq $False } |
Where { $_.surname -ne $null -and $_.givenname -ne $null -and $_.DisplayName -notlike "*gent*" -and $_.DisplayName`
-notlike "*ervice*" -and $_.DisplayName -notlike "*erritory*" -and $_.DisplayName -notlike "*nderwrit*" -and $_.DisplayName`
-notlike "*account*" -and $_.DisplayName -notlike "*user*" -and $_.DisplayName -notlike "*admin*" -and $_.DisplayName `
-notlike "*prod*" -and $_.DisplayName -notlike "*svc*" -and $_.DisplayName -notlike "*test*"  -and $_.DisplayName -notlike "*email*" `
-and $_.DisplayName -notlike "*receiver*" -and $_.DisplayName -notlike "*_*" -and $_.DisplayName -notlike "*(*" -and $_.DisplayName `
-notlike "*Admin*" -and $_.DisplayName -notlike "*admin*" -and $_.GivenName -notlike "*dmin*" -and $_.SurName -notlike "*dmin*" `
-and $_.GivenName -notlike "*(*" -and $_.SurName -notlike "*(*" -and $_.GivenName -notlike "*test*" -and $_.SurName `
-notlike "*test*" -and $_.GivenName -notlike "*_*" -and $_.SurName -notlike "*_*" -and $_.Title -ne "Service Account" `
-and $_.Title -ne "Shared Mailbox" -and $_.Title -ne "Test Account" } |
Select DisplayName, GivenName, Surname, SamaccountName, EmployeeID, EmailAddress, Title, Department, Office,`
@{Name=”Manager”; Expression={$(get-aduser -identity $_.Manager -Properties DisplayName | Select -ExpandProperty DisplayName)}},`
Company, TelephoneNumber, MobilePhone |
Sort Department, Manager |
Export-csv "$Path\Active AD Users.csv" -notype
