# Note: Needs to be run on win10 environment - will not work on win7

Get-AppxPackage -allusers *Microsoft.MicrosoftStickyNotes* |
Foreach {Add-AppxPackage -DisableDevelopmentMode -Register “$($_.InstallLocation)\AppXManifest.xml”}


