# Import-Module ActiveDirectory
Get-ADUser -Property GivenName, Surname, Title, Department, Company, TelephoneNumber, MobilePhone, Samaccountname, EmailAddress, StreetAddress, City, State, PostalCode -Filter { ObjectClass -eq "user" -and Enabled -eq 'True' -and PasswordNeverExpires -eq $false } |
Where { $_.EmployeeID -eq $null -or $_.EmployeeID -eq " " -and $_.surname -ne $null -and $_.givenname -ne $null -and $_.DisplayName -notlike "*agent*" -and $_.DisplayName -notlike "*service*" -and $_.DisplayName -notlike "*territory*" -and $_.DisplayName -notlike "*underwrit*" -and $_.DisplayName -notlike "*account*" -and $_.DisplayName -notlike "*user*" -and $_.DisplayName -notlike "*admin*" -and $_.DisplayName -notlike "*prod*" -and $_.DisplayName -notlike "*svc*" -and $_.DisplayName -notlike "*test*"  -and $_.DisplayName -notlike "*email*" -and $_.DisplayName -notlike "*receiver*" } |
Select GivenName, Surname, Title, Department, Company, TelephoneNumber, MobilePhone, Samaccountname, EmailAddress, StreetAddress, City, State, PostalCode |
Export-csv c:/salesforce.csv -notype

# 
# -and EmailAddress -notlike "*@icwgrp.com" | Where {$_.EmailAddress -ne "*@icwgrp.com" }