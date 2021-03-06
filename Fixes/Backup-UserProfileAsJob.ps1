<# Backup-UserProfileAsJob

# Arturo E Polanco
# 5-21-19

#
# Backs up a users profile from a computer to their personal network share drive
#
# Runs each computer backup as a separate named background job "Backup [ComputerName]"
#
###########################################################################
#
# PARAMETERS
#
# param Computer -  Mandatory  -  Computer name[s]  -  Can be piped
# 
# param User     -  Optional   -  User
#
# param Folder   -  Optional   -  Folder list <-- Not tested! DO NOT USE!
#
############################################################################ 
#
# EXAMPLES
#
# > Backup-UserProfileAsJob -Computer SANLPC0GMDM8
# 
#
# > Backup-UserProfileAsJob -Computer SANLPC0GMDM8 -User apolanco
#
#
# > Get-Content -Path "\\Path\to\File\List of Computers.txt" | Backup-UserProfileAsJob
#
#
# > Export-CSV "\\Path\to\CSV\List of Computers.csv | Select "[Header for Computers Column]" | Backup-userProfileAsJob 
# 
#  
############################################################################>

function Backup-UserProfileAsJob {
  
  [CmdletBinding()]
  param (
    [parameter(mandatory=$true,ValueFromPipeline=$true)][ValidateNotNullOrEmpty()]$Computer,
    [parameter(mandatory=$false)][string]$User,
    [parameter(mandatory=$false)]
    [ValidateSet('ALL','Desktop','Documents','Downloads','Favorites','Pictures','AppData\Local\Mozilla','AppData\Local\Google','AppData\Roaming\Mozilla','AppData\Roaming\Microsoft\Signatures')]
    $Folder
  )
  
  Begin {
    
    # Add folders under "C:\Users\[username]\" to be backed up or restored
    if(($Folder -eq $Null) -or ($Folder -eq "ALL") -or ($Folder -eq "")){
      $Folder = "Desktop",
        "Favorites",
        "Documents",
        "Pictures",
        "AppData\Local\Mozilla",
        "AppData\Local\Google",
        "AppData\Roaming\Mozilla",
        "AppData\Roaming\Microsoft\Signatures"
    }
       
  }
   
  Process {  

    Foreach ($Comp in $Computer) {
    
      $scriptblock = {
        
        # Computer
        $Compy = $args[0]
      
        # User
        if(!($args[1] -eq $null) -and !($args[1] -eq '')) {
          $User = $args[1]
        }
            
        if(($User -eq $null) -or ($User -eq '')) {
          $User = (Get-WmiObject Win32_ComputerSystem -ComputerName $args[0] -ErrorAction Stop).UserName.Split('\')[1]        
        }
        
        if(($User -eq $null) -or ($User -eq '')) {
          Write-Host -ForegroundColor red " No User to back up on $Compy!! Exiting... "
          return $true
        }
        
        # Folder(s)
        if(!($args[2] -eq $null) -and !($args[2] -eq '')) {
          $Folder = $args[2]
        }
    
        $userprofile = "\\$Compy\C$\Users\$user"
        $destination = "\\sancfs001.icwgrp.com\icwusers$\$user\Win10-Backup"

        if(!(test-path $destination)) {
          mkdir $destination
        }
  
        Write-Host -ForegroundColor White " Backing up $User's profile to $destination..."
  
        foreach ($f in $folder) {
          $localFolder = $userprofile + "\" + $f
          if(!(Test-Path $localFolder)) {
            break
          }
          $remoteFolder = $destination + "\" + $f
          $folderSize = (Get-ChildItem -ErrorAction silentlyContinue $localFolder -Recurse -Force |
           Measure-Object -ErrorAction silentlyContinue -Property Length -Sum ).Sum / 1MB
          $folderSizeRounded = [System.Math]::Round($folderSize)
          Write-Host -ForegroundColor cyan "  $User\$f... ($folderSizeRounded MB)"
          Copy-Item -ErrorAction silentlyContinue -Recurse $localFolder $remoteFolder -Force
	      }
      
        Write-Host -ForegroundColor green "Backup complete for $User on $Compy"
      
      } # Scriptblock
      
      Start-Job -ScriptBlock $Scriptblock -Name "Backup $User from $Comp" -ArgumentList $Comp, $User, $Folder
      
    }
    	
  } # End Process

  End {		    	
    #write-host -ForegroundColor green "Backup complete!"
  } 

} #End of Backup-UserProfile Function