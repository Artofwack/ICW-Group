$username = $env:username
$sourceDir = "C:\Users\$username\Desktop\New Folder"
$destination = "\\sancfs001\icwusers$\$username\Win10-Backup\"

$items = Get-ChildItem $sourceDir -recurse

foreach ($item in $items)
{
  if ($item.PsIsContainer)
  {
    $itemName = $item.FullName
    $folder = "$destination\$itemName"
    
    mkdir $folder
  }
  else {

    Move-Item -Path $item.FullName -Destination $destination

    $wshshell = New-Object -ComObject WScript.Shell
    $lnk = $wshshell.CreateShortcut($sourceDir + "\$itemName.lnk")
    $lnk.TargetPath = "$destination"
    $lnk.Save()
  }
}