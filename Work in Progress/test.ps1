$User = Get-ADUser apolanco -Properties DisplayName, SamAccountName, EmailAddress, Title, Department, Manager

$Manager = $User | Select-Object -ExpandProperty @{expression={$_.manager -replace '^CN=|,.*$'}}

$User
$Manager


#get-aduser apolanco -properties DisplayName, Department, Title, Manager, Emailaddress, Samaccountname | Select DisplayName, SamaccountName, EmailAddress, Title, Department, Manager= | Export-csv c:/users/apolanco/desktop/a.csv -notype
#get-aduser apolanco - properties Manager 
