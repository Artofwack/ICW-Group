# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

Get-ADUser -Filter { Enabled -eq $true  } -Properties DisplayName, EmployeeID, GivenName, Surname, emailaddress, Department, Company |
Where { $_.EmployeeID -eq $null -or $_.EmployeeID -eq " " -and $_.surname -ne $null -and $_.givenname -ne $null -and $_.DisplayName -notlike "*agent*" -and $_.DisplayName -notlike "*service*" -and $_.DisplayName -notlike "*erritory*" -and $_.DisplayName -notlike "*nderwrit*" -and $_.DisplayName -notlike "*account*" -and $_.DisplayName -notlike "*user*" -and $_.DisplayName -notlike "*admin*" -and $_.DisplayName -notlike "*prod*" -and $_.DisplayName -notlike "*svc*" -and $_.DisplayName -notlike "*test*"  -and $_.DisplayName -notlike "*email*" -and $_.DisplayName -notlike "*receiver*" -and $_.DisplayName -notlike "*_pdc*" -and $_.DisplayName -notlike "*_rib*" -and $_.DisplayName -notlike "*xperienc*" -and $_.DisplayName -notlike "*support*" -and $_.DisplayName -notlike "*nsurance*" -and $_.DisplayName -notlike "*_opr*" -and $_.DisplayName -notlike "*(*" -and $_.DisplayName -notlike "*agent*" -and $_.DisplayName -notlike "*service*" -and $_.DisplayName -notlike "*erritory*" -and $_.DisplayName -notlike "*nderwrit*" -and $_.DisplayName -notlike "*account*" -and $_.DisplayName -notlike "*user*" -and $_.DisplayName -notlike "*admin*" -and $_.DisplayName -notlike "*prod*" -and $_.DisplayName -notlike "*svc*" -and $_.DisplayName -notlike "*test*"  -and $_.DisplayName -notlike "*email*" -and $_.DisplayName -notlike "*receiver*" -and $_.DisplayName -notlike "*_pdc*" -and $_.DisplayName -notlike "*_rib*" -and $_.DisplayName -notlike "*xperienc*" -and $_.DisplayName -notlike "*support*" -and $_.DisplayName -notlike "*nsurance*" -and $_.DisplayName -notlike "*_opr*" -and $_.DisplayName -notlike "*(*"  }  |
Select DisplayName, GivenName, Surname, samaccountname, EmailAddress, Department, Company, EmployeeID |
Sort Surname |
Export-csv c:\users\apolanco\desktop\empid.csv -notype

