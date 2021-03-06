# Backup Desktop 
# Arturo E Polanco
# 5-21-19

#
# Backs up a users profile to their personal share drive
#
###########################################################################
#
# param Computer -  Mandatory computer name
# 
#
# 
############################################################################

function Backup-UserProfile {
  param (
    [parameter(mandatory=$true)][string]$Computer
  )

############################################################################

  # Add folders under "c:\users\username\" to be backed up or restored

  $folder = "Desktop",
  "Favorites",
  "Documents",
  "Pictures",
  "AppData\Local\Mozilla",
  "AppData\Local\Google",
  "AppData\Roaming\Mozilla"

  $username = (get-wmiobject Win32_ComputerSystem -comp $Computer).UserName.Split('\')[1]
  $userprofile = "\\$Computer\C$\Users\$username"
  $appData = "\\$Computer\C$\Users\$username\APPDATA"

  $destination = "\\sancfs001.icwgrp.com\icwusers$\$username\Win10-Backup"


############################################################################
  
  if(!(test-path $destination))
    {
        mkdir $destination
    }
  
  foreach ($f in $folder)
	{	
		$currentLocalFolder = $userprofile + "\" + $f
		$currentRemoteFolder = $destination + "\" + $f
		$currentFolderSize = (Get-ChildItem -ErrorAction silentlyContinue $currentLocalFolder -Recurse -Force | Measure-Object -ErrorAction silentlyContinue -Property Length -Sum ).Sum / 1MB
		$currentFolderSizeRounded = [System.Math]::Round($currentFolderSize)
		write-host -ForegroundColor cyan "  $f... ($currentFolderSizeRounded MB)"
		Copy-Item -ErrorAction silentlyContinue -recurse $currentLocalFolder $currentRemoteFolder
	}	
	
	    
	
  write-host -ForegroundColor green "Backup complete for $Computer!"
  
 } #End of Function