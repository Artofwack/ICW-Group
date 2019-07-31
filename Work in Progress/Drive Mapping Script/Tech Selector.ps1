[System.Reflection.Assembly]::LoadWithPartialName('microsoft.visualbasic')| Out-Null
[Microsoft.VisualBasic.Interaction]::InputBox("Who should get next ticket?", "Tech Selector" , "Press ok to see who should take the next ticket")
$a = ("Jerrel Can Do It!" , "Give it to Jerrel, he's not busy." , "Jerrel again." , "Boom! Jerrel's." , "Jerrel needs something to do." , "Jerrel is playing on his phone, he can take it." , "Jerrel." , "I think I saw Jerrel starting to fall asleep.  Give it to him." , "Definitely Jerrel." , "Jerrel is faking being busy, he should get it." , "Jerrel loves tickets.  He should have it." , "Jerrel is a go getter.  Give him the ticket" , "Jerrel is bored.  He wants it.")
$m = $a | Get-Random 
[System.Windows.Forms.MessageBox]::Show("$m")