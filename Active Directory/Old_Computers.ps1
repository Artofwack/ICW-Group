# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}
$domain = “icwpdc-sd.icwgrp.com”
$DaysInactive = 30
$time = (Get-Date).Adddays(-($DaysInactive))

# Get all AD computers with lastLogonTimestamp less than our time
Get-ADComputer -Filter {Enabled -eq $true -and LastLogonTimeStamp -lt $time -and OperatingSystem -notlike "Windows Server*"} -Properties OperatingSystem, OperatingSystemVersion, LastLogonTimeStamp |
#select Name, LastLogonTimeStamp | Export-Csv ComputerCleanup.csv -notype
# Output hostname and lastLogonTimestamp into CSV
select Name, @{Name=”Logon Stamp”; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}}, OperatingSystem, OperatingSystemVersion | Sort "Logon Stamp", OperatingSystemVersion, operatingSystem | export-csv "$env:userprofile\desktop\OLD_Computer.csv" -notypeinformation

