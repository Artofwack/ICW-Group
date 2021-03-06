# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

# Prompt for user
$userName = Read-Host -Prompt "Input the UserName"

# Find user associated with entry
$user = Get-Aduser $Username

# Import list of Ad Groups to add user to
$ADgroups = Import-CSV "\\sancfs001\public$\apolanco\Scripts\Work in Progress\Groups.csv"

Foreach ($Group in $ADGroups ) {
  # Get Ad Group Object based on name
  $Group1 = Get-ADGroup $Group.Name
  # Add user to AD Group Object
  Add-ADPrincipalGroupMembership $User -Memberof $Group1
}