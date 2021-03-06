# Contract Accounts set to Expire
# Arturo E Polanco
# 1-2-19

#
# Returns list of user accounts that are set to expire during a date interval
#
###########################################################################
#
# Exports list of Ad users that will expire within a Start and End date.
# 
# All accounts that are to be extended need to have an official Contractor Extension Notice 
# from  Reception. The manager will need to request the extension from Reception or fill out an
# Employee Separation notice if the contract is not to be extended.  
# 
############################################################################

# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
  Import-Module ActiveDirectory
}

# Date Interval - Default is set to expired as of 10 days ago with 45 day interval
$Date = $(Get-Date).adddays(-10)
$EndDate = $Date.adddays(45)

# CSV file export path
$Path = "$env:userprofile\Desktop"

############################################################################

$Style = @"
<style>
BODY{font-family:Calibri;font-size:12pt;}
TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse; padding-right:5px}
TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black;color:black;background-color:#FFFFFF }
TH{border-width: 1px;padding: 5px;border-style: solid;border-color: black}
TD{border-width: 1px;padding: 5px;border-style: solid;border-color: black}

</style>
"@

############################################################################

$Users = Get-ADUser -Filter { Enabled -eq $True -and AccountExpirationDate -ge $Date -and AccountExpirationDate -le $EndDate } `
-Properties DisplayName, AccountExpirationDate, EmployeeID, Manager, Title, Department |
Select DisplayName, SamAccountName, AccountExpirationDate, Title, Department, `
@{Name=”Manager”; Expression={$(get-aduser -identity $_.Manager -Properties DisplayName |
Select -ExpandProperty DisplayName)}} |
Sort Manager, AccountExpirationDate, DisplayName |
ConvertTo-Html -Head $Style |
Out-File "$Path\Contractors Expiring.html"

$Table = [System.IO.File]::ReadAllText("$Path\Contractors Expiring.html")

$EmailHash = @{
  From = "Service Desk <servicedesk@icwgroup.com>"
  To = "Reception <reception@icwgroup.com>"
  BCC = "Arturo Polanco <apolanco@icwgroup.com>"
  Subject = 'Contractor Accounts Expiring soon'
  Body = "<p>Contractor Accounts set to expire soon. Note that some accounts may be Temp Users</p><br><p>$Table"
  smtpserver = 'casarray1.icwgrp.com'
}

Send-MailMessage @EmailHash -BodyAsHtml

Remove-Item "$Path\Contractors Expiring.html"