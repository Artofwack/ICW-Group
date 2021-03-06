# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Path = "c:\users\apolanco\desktop"

get-aduser -filter * -Properties EmployeeID, EmailAddress, DisplayName, Title, Manager, Department  |
where { $_.EmployeeID -ne " " -and $_.EmployeeID -ne $null} |
Select EmployeeID, DisplayName, Title, @{Name=”Manager”; Expression={$(get-aduser $_.Manager -Properties DisplayName | Select -ExpandProperty DisplayName)}}, Department |
Export-csv -notype $Path\adusers.csv