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
# day period, the account is to be disabled and Service Desk will note this in the ticket.
#
#
# Service Desk is to use "Service Desk Quarterly Ad Reconcile {DATE MM/DD/YY}" as the short description for the Service Now ticket.
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

$startDate = Get-Date('3/05/2019')
$endDate = Get-Date('11/01/2018')

Get-ADUser -properties * `
-filter {(lastlogondate -notlike "*" -or lastlogondate -le $startDate) -and (enabled -eq $True -and PasswordNeverExpires -eq $False)} | 
Where {  $_.surname -ne $null -and $_.givenname -ne $null -and $_.DisplayName -notlike "*agent*" `
-and $_.DisplayName -notlike "*ervice*" -and $_.DisplayName -notlike "*erritory*" -and $_.DisplayName -notlike "*nderwrit*" `
-and $_.DisplayName -notlike "*ccount*" -and $_.DisplayName -notlike "*user*" -and $_.DisplayName -notlike "*admin*" `
-and $_.DisplayName -notlike "*prod*" -and $_.DisplayName -notlike "*svc*" -and $_.DisplayName -notlike "*test*"  `
-and $_.DisplayName -notlike "*email*" -and $_.DisplayName -notlike "*eceiver*" } |
Select employeeID, displayName, samAccountName, title, department, manager, lastlogondate |
Sort lastLogonDate, department, manager |
#Format-Table -Wrap -Autosize -Groupby department
Export-Csv -notype "\\sancfs001.icwgrp.com\public$\apolanco\Scripts\Active Directory\Results\AD Reconcile Range.csv"   
