# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}


$TermDate = $(Get-Date).AddDays(-5)

$Users = Get-ADUser -Filter {(Enabled -eq $False)} -Properties DisplayName, whenChanged, EmailAddress, accountexpirationdate |
Where { $_.whenchanged -gt $TermDate -and $_.accountexpirationdate -gt $TermDate }


$Query = "Select Id, Username, LastName, FirstName, Email FROM User WHERE Email IN (" 

Foreach ($TermedUser in $Users ){
  if ($TermedUser.EmailAddress -ne $null) {
    if($Query[-1] -ne "(" ) {
      $Query = $Query + ", '" + $TermedUser.EmailAddress + "'"
    }
    else{
      $Query = $Query + "'" + $TermedUser.EmailAddress + "'"
    }
  }
}

$Query = $query + ")"

$Query > "C:\Data Loader\input\disabled-contacts-prod.txt"

$Query > "C:\Data Loader\input\disabled-users-prod.txt"