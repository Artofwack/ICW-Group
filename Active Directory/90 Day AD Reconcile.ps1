# Service Desk 90 day AD Account Reconcile
# Arturo E Polanco
# 10-26-18

#
# Returns list of users that have not logged on to AD account in the previous XX days
#
###########################################################################
#
#
# Exports list of Ad users that have not logged on to their AD account in the previous XX days from current date or at all.
#
# This list is to be retrieved every 90 days at a minimum by Service Desk and all accounts listed are to be forwarded to the
#
# user's manager for review. Service Desk will open a Task ticket to track this quarterly review and attach this list to the 
#
# Service Now ticket. Managers will then have 10 business days to respond to Service Desk. Any accounts that are to be
#
# disabled per the manager are to be treated as an Employee Separation. If there is no response from the manager after the 10
#
# business day period, the account is to be disabled and Service Desk will note this in the ticket.
#
#
# Service Desk is to use "Service Desk Quarterly Ad Reconcile" as the short description for the Service Now ticket.
# 
#
# $Date is inclusive - ($Date, ..., ..., current date)
#
# 
############################################################################


# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

#Path
$Path = "$env:userprofile\Desktop" #"\\sancfs001.icwgrp.com\icwusers$\apolanco\Scripts\Active Directory\Results"

$Date = (Get-Date).adddays(-30)
#$Date = Get-Date('1/01/2019')

Get-ADUser -properties * `
-filter {(lastlogondate -notlike "*" -or lastlogondate -le $Date) -and (Enabled -eq $True -and PasswordNeverExpires -eq $False)} | 
Where {  $_.surname -ne $null -and $_.givenname -ne $null -and $_.DisplayName -notlike "*agent*" `
-and $_.DisplayName -notlike "*ervice*" -and $_.DisplayName -notlike "*erritory*" -and $_.DisplayName -notlike "*nderwrit*" `
-and $_.DisplayName -notlike "*ccount*" -and $_.DisplayName -notlike "*user*" -and $_.DisplayName -notlike "*admin*" `
-and $_.DisplayName -notlike "*prod*" -and $_.DisplayName -notlike "*svc*" -and $_.DisplayName -notlike "*test*"  `
-and $_.DisplayName -notlike "*email*" -and $_.DisplayName -notlike "*eceiver*" -and $_.DisplayName -notlike "*_pdc*" `
-and $_.Title -notlike "Service Account*" -and $_.Title -notlike "Risk Ins Brokers Account*" `
-and $_.Title -notlike "On Point Risk Account*" -and $_.Title -notlike "Test Account" `
-and $_.Title -notlike "Shared Mailbox*"} |
Select DisplayName, samAccountName, Title, Company, LastLogonDate, accountExpirationDate, `
@{Name=”Manager”; Expression={$(get-aduser -identity $_.Manager -Properties DisplayName |
Select -ExpandProperty DisplayName)}} |
Sort Manager, lastLogonDate, accountExpirationDate |
Export-Csv -notype "$Path\AD Reconcile $(get-date -f MM-dd-yyyy_hh_mm).csv"
