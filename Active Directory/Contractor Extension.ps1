# Contract Accounts set to Expire
# Arturo E Polanco
# 12-28-18

#
# Sets Contractor account expiration dates
#
###########################################################################
#
# Sets the expiration date to $EndDate for all user accounts pulled from CSV from Reception
# 
# All accounts that are to be extended need to have an official Contractor Extension Notice 
# from  Reception. The manager will need to request the extension from Reception or fill out an
# Employee Separation notice if the contract is not to be extended. 
#
# 
############################################################################

# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$EndDate = get-Date('04/30/2020')

$Path = "c:\users\apolanco\desktop"

$Users = Import-Csv "$Path\users.csv"

############################################################################

foreach ($User in $Users) {
  Try{
    $Username = Get-aduser -filter { enabled -eq $True -and PasswordNeverExpires -eq $False } -Properties displayName, givenName, surName, AccountExpirationDate |
    Where { $_.SurName -eq $User.LastName -and $_.GivenName -eq $User.FirstName } 
    
    if ($Username -ne $Null){
      Set-AdUser $Username -AccountExpirationDate $EndDate
      "updated Expiration date for " + $Username.displayName +  " `n" >> "$Path\log.txt" 
    }else {
      "------------------------ Unable to find " + $User.LastName + ", " + $User.FirstName + " `n" >> "$Path\log.txt"
    }    
    
  } Catch {
    "------------------------ Unable to update " + $User.LastName + ", " + $User.FirstName + " `n" >> "$Path\log.txt"
  }
}