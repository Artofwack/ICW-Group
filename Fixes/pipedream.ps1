# Backup-UserProfile

# Arturo E Polanco
# 5-21-19

#
# Backs up a users profile to their personal share drive
#
###########################################################################
#
# param Computer -  Mandatory  -  Computer name
# 
# param User     -  Optional   -  User
#
# param Folder   -  Optional   -  Folder list
#  
############################################################################

function Backup-UserProfile {
  
  [CmdletBinding()]
  param (
    [parameter(mandatory=$true,ValueFromPipeline=$true)]$Computer,
    [parameter(mandatory=$false)]$User,
    [parameter(mandatory=$false)]$Folder
  )
  
Begin
  {
    


    # Add folders under "C:\Users\[username]\" to be backed up or restored

    $Folder = "Desktop",
    "Favorites",
    "Documents",
    "Pictures",
    "AppData\Local\Mozilla",
    "AppData\Local\Google",
    "AppData\Roaming\Mozilla"
    

    
  
    
  

    
  }

############################################################################
 
Process
  {  

   Foreach ($Comp in $Computer){
    
    if($user -eq '')
      {
         $User = (Get-WmiObject Win32_ComputerSystem -ComputerName $Comp).UserName.Split('\')[1]
      }
    
    $userprofile = "\\$Comp\C$\Users\$user"
    $destination = "\\sancfs001.icwgrp.com\icwusers$\$user\Win10-Backup"

    if(!(test-path $destination))
      {
        mkdir $destination
      }
  
    Write-Host -ForegroundColor blue " Backing up $User's profile to $destination..."
  
    foreach ($f in $folder)
	  {	
	    $localFolder = $userprofile + "\" + $f
		$remoteFolder = $destination + "\" + $f
		$folderSize = (Get-ChildItem -ErrorAction silentlyContinue $localFolder -Recurse -Force | Measure-Object -ErrorAction silentlyContinue -Property Length -Sum ).Sum / 1MB
		$folderSizeRounded = [System.Math]::Round($folderSize)
		Write-Host -ForegroundColor cyan "  $User\$f... ($folderSizeRounded MB)"
		Copy-Item -ErrorAction silentlyContinue -Recurse $localFolder $remoteFolder
	  }
    }	
  } # End Process

End
  {		    	
    write-host -ForegroundColor green "Backup complete!"
  } 

} #End of Backup-UserProfile Function