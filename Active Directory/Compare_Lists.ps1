# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Users = Import-CSV -Path ".\DG-PowerBI Pro Users members.csv"

$List = Import-CSV -Path ".\Userlist.csv"

$ExistsinGroup = @()
$NotinGroup = @()

foreach ($ListUser in $Users){
  $match = $List | Where {$_.EmailAddress -eq $ListUser.EmailAddress} 
  if ($match) {    
    $ExistsinGroup += New-Object PSObject -Property @{DisplayName =$ListUser.DisplayName; EmailAddress =$ListUser.EmailAddress}
  } else {
    $NotinGroup += New-Object PSObject -Property @{DisplayName =$ListUser.DisplayName; EmailAddress =$ListUser.EmailAddress}
  } 
}

$ExistsinGroup | Export-Csv -notype ".\ExistsinGroup.csv"

$NotinGroup | Export-Csv -notype ".\NotinGroup.csv"