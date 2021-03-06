$username = $env:username
$sourceDir = "C:\Users\$username\Desktop\New Folder"
$targetDir = "\\sancfs001\icwusers$\$username\Win10-Backup\"

$items = Get-ChildItem $sourceDir -recurse | Where-Object {!$_.PsIsContainer}

foreach ($item in $items)
{
  $withoutRoot = $item.FullName.Substring([System.IO.Path]::GetPathRoot($item.FullName).Length);
  $itemPath = (get-item $item.FullName).directory.parent.name
  $destination = Join-Path -Path $targetDir -ChildPath $withoutRoot

  $dir = Split-Path $destination
  if (!(Test-Path $dir))
  {
    mkdir $dir
  }

  
  Move-Item -Path $item.FullName -Destination $destination
 
  
  $ItemName = $Item.BaseName
  $wshshell = New-Object -ComObject WScript.Shell
  $desktop = [System.Environment]::GetFolderPath('Desktop')
  $lnk = $wshshell.CreateShortcut($sourceDir + "\$ItemName.lnk")
  $lnk.TargetPath = "$destination"
  $lnk.Save()
  
}