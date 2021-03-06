# Set Employee ID for AD Users
# Arturo E Polanco
# 9-12-18


###########################################################################
#
#  Sets Employee ID in AD for existing User
# 
# 
############################################################################


# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Username = Read-Host -Prompt "Input the Username"

$EmployeeID = Read-Host -Prompt "Input the Employee ID"

Try{
  Set-ADUser $User.SamAccountName -EmployeeId $EmployeeID
}
Catch {
  
}