# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$List = @()

$Computers = $(get-adcomputer SANLT12OC75 -Properties *) | % -scriptblock #Get-ADComputer -Filter {Enabled -eq $true -and (OperatingSystem -eq "Windows 7 Enterprise" -or OperatingSystem -eq "Windows 10 Enterprise")} -Properties OperatingSystem |
 {
  $Computer = $_
  $ComputerName = $_.Name
  $List += New-Object -TypeName PSObject -Property @{
              'IP' = $_.ipv4address #[System.Net.Dns]::GetHostAddresses("$Computer") | select -ExpandProperty IPAddressToString
              'Computer' = $ComputerName
              'User' = (Get-WmiObject Win32_ComputerSystem -ComputerName $ComputerName -ErrorAction silentlycontinue).UserName.Split('\')[1]
           }
  $ComputerName
 
}


