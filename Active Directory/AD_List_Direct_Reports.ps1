# Contract Accounts set to Expire
# Arturo E Polanco
# 1-2-19

#
# Returns list of user accounts that are set to expire during a date interval
#
###########################################################################
#
# Exports list of Ad users that will expire within a Start and End date.
# 
# All accounts that are to be extended need to have an official Contractor Extension Notice 
# from  Reception. The manager will need to request the extension from Reception or fill out an
# Employee Separation notice if the contract is not to be extended.  
# 
############################################################################

# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Path = "$ENV:USERPROFILE\desktop" # "\\sancfs001\public$\apolanco\Scripts\Active Directory\Results"

############################################################################

$Man = Read-Host -Prompt "Enter Manager" 

$Manager = Get-ADUser -Filter { DisplayName -eq $Man -or SamAccountName -eq $Man } | Select -ExpandProperty DistinguishedName


Get-ADUser -Filter { Enabled -eq $TRUE -and Manager -eq $Manager } -Properties DisplayName, Title, Company, Manager, AccountExpirationDate  |
Select DisplayName, Title, Company, AccountExpirationDate |
Sort DisplayName |
Export-CSV -notype "$Path\$Man Direct Reports.csv"
