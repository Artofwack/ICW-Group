[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

$formVS = New-Object System.Windows.Forms.Form
  $formVS.size = New-Object System.Drawing.size(800,640)
  $formVS.TopMost = $true
  $formVS.ControlBox = $true
  $formVS.MaximizeBox = $false
  $formVS.MinimizeBox = $false
  

$formVS.ShowDialog()
