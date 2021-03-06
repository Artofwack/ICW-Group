# Backup Desktop 
# Arturo E Polanco
# 5-21-19

#
# Backs up a users desktop and creates shortcut links to moved items on desktop
#
###########################################################################
#
#
# 
#
# 
############################################################################


$username = $env:username
$sourceDir = "C:\Users\$username\Desktop"
$targetDir = "\\sancfs001.icwgrp.com\icwusers$\$username\Win10-Backup\Desktop"

$dir = split-path $targetDir
if(!(test-path $dir))
{
  mkdir $dir
}

if(!(test-path $targetDir))
{
  mkdir $targetDir
}


$items = Get-ChildItem $sourceDir


foreach ($item in $items)
{
  $ItemBaseName = $Item.BaseName
  
  $ItemName = $Item.Name
  
    
  if (!($item.PsIsContainer))
  {
    try
    {
      $destination = join-path $targetDir -childpath $itemName
      Copy-Item $item.FullName -Exclude "*.lnk" -destination "$destination" -ErrorAction Stop
      
      Remove-Item -Recurse $item.FullName
    }
    catch {}
  }
  else
  { 
    try
    {
      $destination = join-path $targetDir -childpath $itemBaseName
      Copy-Item -Recurse $item.FullName -destination "$destination" -ErrorAction Stop -Container
      
      Remove-Item -Recurse $item.FullName
    }
    catch {}
  }
  
  $wshshell = New-Object -ComObject WScript.Shell
  $lnk = $wshshell.CreateShortcut($sourceDir + "\$itemBaseName.lnk")
  $lnk.TargetPath = "$destination"
  $lnk.Save()  
  
}