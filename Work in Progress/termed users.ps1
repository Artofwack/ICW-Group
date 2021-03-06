# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

#$OrgUnit = Get-ADOrganizationalUnit -Filter { Name -eq "Termed Users" } | Select -ExpandProperty DistinguishedName

get-aduser -Filter * |
#Where { $_.CanonicalName -like "'ICWPDC-SD.ICWGRP.com/Termed Users/EWilson"} |
Select DisplayName
