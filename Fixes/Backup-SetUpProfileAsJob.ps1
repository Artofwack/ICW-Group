<#
#>

function Backup-SetUpProfileAsJob {
  
  [CmdletBinding()]
  param (
    [parameter(mandatory=$false,ValueFromPipeline=$true)]$Computer,
    [parameter(mandatory=$false)][string]$User,
    [parameter(mandatory=$false)]
    [ValidateSet('ALL','Desktop','Documents','Downloads','Favorites','Pictures','AppData\Local\Mozilla','AppData\Local\Google','AppData\Roaming\Mozilla','AppData\Roaming\Microsoft\Signatures')]
    $Folder
  )
  
  begin {
    if(($Computer -eq $Null) -or ($Computer -eq '')){
      $Computer = gwmi -Class Win32_ComputerSystem | Select -ExpandProperty Name
    }

    if(($Folder -eq $Null) -or ($Folder -eq '') -or ($Folder -eq "ALL")){
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
  
  process {
    
    Foreach ($Comp in $Computer) {
    
      $scriptblock = {
        
        $Compy = $args[0]
      
        $Folder = $args[2]
      
        if(!($args[1] -eq $null) -and !($args[1] -eq '')) {
          $User = $args[1]
        }
            
        if(($User -eq $null) -or ($User -eq '')) {
          $User = (Get-WmiObject Win32_ComputerSystem -ComputerName $args[0] -ErrorAction Stop).UserName.Split('\')[1]        
        }
        
        if(($User -eq $null) -or ($User -eq '')) {
          Write-Host -ForegroundColor red " No User to set up on $Compy!! Exiting... "
          return $true
        }
    
        $userprofile = "\\$Compy\C$\Users\$user"
        $profilebackup = "\\sancfs001.icwgrp.com\icwusers$\$user\Win10-Backup"

        if(!(test-path $profilebackup)) {
          Write-Host -ForegroundColor red "No user profile backup available"
          return $true
        }
  
        Write-Host -ForegroundColor White " Restoring $User's profile to $profilebackup..."
  
        foreach ($f in $folder) {	
          $remoteFolder = $profilebackup + "\" + $f
          if(!(Test-Path $remoteFolder)) {
            break
          }
          $localFolder = $userprofile + "\" + (split-path $f)
          $folderSize = (Get-ChildItem -ErrorAction silentlyContinue $remoteFolder -Recurse -Force |
           Measure-Object -ErrorAction silentlyContinue -Property Length -Sum ).Sum / 1MB
          $folderSizeRounded = [System.Math]::Round($folderSize)
          Write-Host -ForegroundColor cyan "  $User\$f... ($folderSizeRounded MB)"
          Copy-Item -ErrorAction SilentlyContinue -Recurse $remoteFolder $localFolder
	      }
      
        Write-Host -ForegroundColor green "Restore complete for $User on $Compy"
      
      } # Scriptblock
      
      Start-Job -ScriptBlock $Scriptblock -Name "Set up $User on $Comp" -ArgumentList $Comp, $User, $Folder
    
    } #End ForEach 
  }
  
  end {
  }
  
} #End