# Termed Users
# Arturo E Polanco
# 2-27-19

#
# Returns list of users and their account status to cross reference with HR
# 
# term list on a bi-monthly basis
#
###########################################################################
#
# 
#
# 
# 
############################################################################

# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}


$Path = "C:\users\apolanco\desktop"

$Terms = Import-Csv -Path $Path\Terms.csv

foreach ($Term in $Terms){
  $ID = $Term.ID
    
  get-aduser -LDAPFilter "(EmployeeID=*$ID)" -Properties Enabled, DisplayName, EmployeeID, accountExpirationdate | Select DisplayName, EmployeeID, accountExpirationdate, Enabled
  
}