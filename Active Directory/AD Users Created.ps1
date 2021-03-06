# AD Users Created
# Arturo E Polanco
# 10-26-18

#
# Returns list of users created during a date interval
#
###########################################################################
#
# Exports list of Ad users that were created within a Start and End date. Attemps to filter as many service accounts as possible.
# 
# Start date is inclusive, end date is exclusive - (startDate, ..., ...], endDate
# 
############################################################################

# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Path = "C:\users\apolanco\desktop" #"\\sancfs001\public$\apolanco\Scripts\Active Directory\Results"

#$createDate = $(Get-Date).AddDays(-90) 
$startDate = Get-Date('7/01/2018')
$endDate = Get-Date('5/30/2019')

$Users = Get-ADUser -Filter * `
-Properties DisplayName, whenChanged, EmailAddress, whenCreated, EmployeeID, Title, Department, Manager, Company |
Where { $_.whencreated -ge $startDate -and $_.whencreated -lt $endDate -and $_.surname -ne $null -and $_.givenname -ne $null `
-and $_.DisplayName -notlike "*agent*" -and $_.DisplayName -notlike "*service*" -and $_.DisplayName -notlike "*territory*" `
-and $_.DisplayName -notlike "*underwrit*" -and $_.DisplayName -notlike "*account*" -and $_.DisplayName -notlike "*user*" `
-and $_.DisplayName -notlike "*admin*" -and $_.DisplayName -notlike "*prod*" -and $_.DisplayName -notlike "*svc*" `
-and $_.DisplayName -notlike "*test*"  -and $_.DisplayName -notlike "*email*" -and $_.DisplayName -notlike "*receiver*"} |
Select EmployeeID, samAccountName, DisplayName, Title, Department, Company, `
@{Name=”Manager”; Expression={$(get-aduser $_.Manager -Properties DisplayName | Select -ExpandProperty DisplayName)}}, whenCreated |
Sort whenCreated |
Export-csv "$Path\New Users.csv" -NoTypeInformation