function Get-MappedDrives($ComputerName){
  $Report = @() 
  #Ping remote machine, continue if available
  if(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet){
    
    Try {
      #Get remote explorer session to identify current user
      $explorer = Get-WmiObject -ComputerName $ComputerName -Class win32_process | ?{$_.name -eq "explorer.exe"}
    }catch{
      "GWMI Error`n`r"
      $ComputerName >> "$env:userprofile\Desktop\comp.txt"
      return
    }
    
    #If a session was returned check HKEY_USERS for Network drives under their SID
    if($explorer){
      $Hive = [long]$HIVE_HKU = 2147483651
      $sid = ($explorer.GetOwnerSid()).sid
      $owner  = $explorer.GetOwner()
      $RegProv = get-WmiObject -List -Namespace "root\default" -ComputerName $ComputerName | Where-Object {$_.Name -eq "StdRegProv"}
      $DriveList = $RegProv.EnumKey($Hive, "$($sid)\Network")
      
      #If the SID network has mapped drives iterate and report
      if($DriveList.sNames.count -gt 0){
        $Person = "$($owner.Domain)\$($owner.user)"
        foreach($drive in $DriveList.sNames){
	  $hash = @{
	    ComputerName	= $ComputerName
	    User		= $Person
	    Drive		= $drive
	    Share		= "$(($RegProv.GetStringValue($Hive, "$($sid)\Network\$($drive)", "RemotePath")).sValue)"
	  }
	    
	  $objDriveInfo = new-object PSObject -Property $hash
	    
	  $Report += $objDriveInfo
        }
      }else{
	  $hash = @{
	    ComputerName	= $ComputerName
	    User		= $Person
	    Drive		= ""
	    Share		= "No mapped drives"
	  }
	  $objDriveInfo = new-object PSObject -Property $hash
	  $Report += $objDriveInfo
      }
    }else{
	$hash = @{
	  ComputerName	= $ComputerName
	  User		= "Nobody"
	  Drive		= ""
	  Share		= "explorer not running"
	}
	$objDriveInfo = new-object PSObject -Property $hash
	$Report += $objDriveInfo
    $ComputerName >> "$env:userprofile\Desktop\comp.txt"
      }
  }else{
      $hash = @{
	ComputerName	= $ComputerName
	User		= "Nobody"
	Drive		= ""
	Share		= "Cannot connect"
      }
      $objDriveInfo = new-object PSObject -Property $hash
      $Report += $objDriveInfo
      $ComputerName >> "$env:userprofile\Desktop\comp.txt"
  }
  return $Report
}

$computernames = Get-Content 'c:\users\apolanco\desktop\comp.Txt'
$CSVpath = "c:\users\apolanco\desktop\Maps.csv"
$CSVReport = @() 

remove-item $CSVpath 

foreach ($computer in $computernames) {
	Write-host $computer 
	$CSVReport += Get-MappedDrives($computer)
}

$CSVReport | Export-Csv -NoTypeInformation -Path $CSVpath
