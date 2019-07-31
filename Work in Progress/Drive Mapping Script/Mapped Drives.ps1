[System.Reflection.Assembly]::LoadWithPartialName('microsoft.visualbasic')| Out-Null
$ComputerName = [Microsoft.VisualBasic.Interaction]::InputBox("Enter Computer Name", "Mapped Drives")
$Drives = Get-WmiObject -ComputerName $ComputerName Win32_MappedLogicalDisk | select Name, ProviderName | Out-String
[System.Windows.Forms.MessageBox]::Show("$Drives", "Mapped Drives on $ComputerName")