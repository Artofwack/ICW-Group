# Termed Users
# Arturo E Polanco
# 11-23-17

#
# Returns list of users that have been termed dring a date range
#
###########################################################################
#
# Exports list of Ad users that were disabled within a Start and End date.
#
# Attemps to filter as many service accounts as possible.
# 
############################################################################



# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Path = "$env:userprofile\desktop"
# "\\sancfs001\public$\apolanco\Scripts\Active Directory\Results"
# "\\sancfs001\internal audit$\AUTOMATION\ACTIVE DIRECTORY\Results"


$StartDate = Get-Date('5/31/2019')
$TermDate = Get-Date('7/10/2019')

$Users = Get-ADUser -Filter { Enabled -eq $false -and PasswordNeverExpires -eq $false } -Properties * |
Where { <#($_.whenchanged -ge $StartDate -and $_.whenchanged -lt $TermDate) -or#> ( $_.accountexpirationdate -ge $StartDate -and $_.accountexpirationdate -lt $TermDate)  } |
Select EmployeeID, DisplayName, samAccountName, Title,`
Department, Company, accountExpirationdate, whenChanged |
Sort whenChanged, accountExpirationDate |
Export-csv "$Path\termed Users.csv" -NoType #$(Get-Date -f MM-dd-yy_hh-mm)