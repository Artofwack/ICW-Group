# Term Users
# Arturo E Polanco
# 7-27-18

#
# Disables a Single User in AD per ICW Policy
#
###########################################################################
#
# Creates a Folder based on the username and exports properties and group membership list each to a csv file within the folder.
#
# Removes User from all groups except 'Domain users'
#
# Moves AD User Object to 'Termed Users' OU
#
# Sets AD User Object settings to Disabled status per ICW policy
#
# Exports User info in Salesforce SOQL query UFormat to find and disable Saleforce user and contact accounts
# 
############################################################################

# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Path = "C:\users\apolanco\desktop"

$NewHires = Import-Csv "$Path\newhires.csv"

$UserHash = New-Object Hashtable

Foreach ($NewHire in $NewHires) {
  $UserHash.
  
  add-aduser $newHire.username -set $UserHash
}