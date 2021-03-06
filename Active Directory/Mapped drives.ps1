$computername = Get-Content "$env:userprofile\Desktop\computers.txt"
$CSVpath = "$env:userprofile\Desktop\MappedDrives.csv"

remove-item $CSVpath -EA 'silentlycontinue' 

$Report = @() 

foreach ($computer in $computername) {
Write-host $computer 

$colDrives = $NULL
$IP = $NULL
$User = $NULL

if(!(Test-Connection -ComputerName $Computer -Quiet -Count 1 )) {continue}

$colDrives = Get-WmiObject Win32_MappedLogicalDisk -ComputerName $computer 
$IP = [System.Net.Dns]::GetHostAddresses("$Computer") | select -ExpandProperty IPAddressToString
$User = (Get-WmiObject Win32_ComputerSystem -ComputerName $Computer -ErrorAction silentlycontinue).UserName.Split('\')[1]
        
foreach ($objDrive in $colDrives) { 
    # For each mapped drive - build a hash containing information
    $hash = @{ 
        ComputerName       = $computer
        IP = $IP
        User = $User
        MappedLocation     = $objDrive.ProviderName 
        DriveLetter        = $objDrive.DeviceId 
    } 
    # Add the hash to a new object
    $objDriveInfo = new-object PSObject -Property $hash
    # Store our new object within the report array
    $Report += $objDriveInfo
}
 
}
# Export our report array to CSV and store as our dynamic file name
$Report | Export-Csv -NoType $CSVpath #$filenamestring