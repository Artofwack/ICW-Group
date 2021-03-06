# Add User to AD Groups
# Arturo E Polanco
# 8-13-18

#
# Adds a User to a list of AD Groups in a CSV file
#
###########################################################################
#
# Adds the user to each of the groups listed in a csv file.
#
# 
############################################################################

# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

# Prompt for user
$Username = Read-Host -Prompt "Input the UserName"

# Find user associated with entry
$User = Get-Aduser $Username

# Ask if user found/selected is correct
$Message  = 'User - ' + $User.DisplayName 
$Question = 'Is ' + $User.DisplayName + ' the correct user?'
  
$Choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$Decision = $Host.UI.PromptForChoice($Message, $Question, $Choices, 0)

if ($Decision -eq 0) {
  Try {
    $ADgroups = Import-CSV "\\sancfs001\public$\apolanco\Scripts\Work in Progress\Groups.csv"
    "Imported Groups" >> "\\sancfs001\public$\apolanco\Scripts\Work in Progress\AddGroupsLog.txt"
  }
  Catch {
    "Could not import CSV" >> "\\sancfs001\public$\apolanco\Scripts\Work in Progress\AddGroupsLog.txt"
  }

  Try {
    Foreach ($Group in $ADGroups ) {
      # Add user to AD Group Object
      Add-ADPrincipalGroupMembership $User -Memberof $Group
      "Added user to $Group" >> "\\sancfs001\public$\apolanco\Scripts\Work in Progress\AddGroupsLog.txt"
    }    
  }
  Catch {
    "Could not add user to $Group" >> "\\sancfs001\public$\apolanco\Scripts\Work in Progress\AddGroupsLog.txt"
  }
}