# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}



$user = Get-ADUser -filter {DisplayName -eq "Christine Locksy" } -Properties displayname, userprincipalname

$user.userprincipalName