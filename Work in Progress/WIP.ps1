# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

#$Computers = Get-ADComputer -Filter {Enabled -eq $true -and (OperatingSystem -eq "Windows 10 Enterprise")} -Properties OperatingSystem  #
$Computers = gc "$env:userprofile\desktop\computers.txt"

$a = @()

$i = 1
$j = 1
Foreach ($Comp in $Computers) {
  
  
  $ComputerName = $Comp.tostring()  
  
  if(!(Test-Connection -ComputerName $ComputerName -Quiet -Count 1 )) {
    "Connection Error " + $j + "  Cannot connect to $ComputerName............"
    $j += 1
    continue      
  }
  else {
    try{
      $objectHash = New-Object -TypeName PSObject -Property @{
        'IP' = [System.Net.Dns]::GetHostAddresses("$ComputerName") | select -ExpandProperty IPAddressToString
        'Computer' = $ComputerName
        'User' = (Get-WmiObject Win32_ComputerSystem -ComputerName $ComputerName -ErrorAction silentlycontinue).UserName.Split('\')[1]
      }
      
      ".................. Connected =  " + $i
      $i += 1
      $a += $objectHash      
    }
    catch {
      
      "Can't find user on $ComputerName.........."
      $User = "Unknown"
      continue
    }
  }
  
}
$a | sort User | Export-Csv -NoTypeInformation "$env:userprofile\desktop\output.csv"
# sanlb5t16m2

# OperatingSystem -eq "Windows 7 Enterprise" -or