$Computers = "sanlcdw16m2" #gc "$env:userprofile\desktop\computers.txt"

Foreach ($Comp in $Computers) {
  if(!(Test-Connection -ComputerName $Comp -Quiet -Count 1 )) {
    "Cannot connect to $Comp............"
    continue  
  }
  else {
    try{
      $User = (Get-WmiObject Win32_ComputerSystem -ComputerName $Comp -ErrorAction silentlycontinue).UserName.Split('\')[1]
    }
    catch {
      "Can't find user on $Comp.........."
      $User = "Unknown"
    }
  }
      
  ".... Connected! ....  $user is online on $comp"
  
  # $Users | Export-CSV -notype $env:userprofile\desktop\computers.txt
      
}
