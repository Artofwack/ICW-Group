# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Username = Read-Host -Prompt "Input the Username"

$user = Get-ADUser $Username -Properties *

# Get Group Membership for user and export to csv file
$ADgroups = Get-ADPrincipalGroupMembership $User.SamAccountName
$ADgroups | Select Name | Export-CSV "\\sancfs001\public$\apolanco\Scripts\Active Directory\Results\Groups.csv" -notype
    
$ADgroups = $ADgroups | where {$_.Name -ne "Domain Users"}
  
if ($ADgroups -ne $null) { Remove-ADPrincipalGroupMembership $User.SamAccountName -MemberOf $ADgroups -Confirm:$false   }
  