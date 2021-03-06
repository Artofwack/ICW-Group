# Get User's Group Membership
# Arturo E Polanco
# 5-24-18

#
# Pulls a detailed list of AD Group Membership
# for a user.
#
# Creates a Folder based on the username and exports 
# group membership list to a csv file within the folder.
# 

# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Path = "$env:userprofile\Desktop"

# Prompt for user
$Username = Read-Host -Prompt "Input the UserName"

# Find user associated with entry
$User = Get-Aduser $Username -Properties DisplayName, Manager, DistinguishedName, Description, EmailAddress, memberof

# Ask if user found/selected is correct
$Message  = 'User - ' + $User.DisplayName 
$Question = 'Is ' + $User.DisplayName + ' the correct user?'
  
$Choices = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$Choices.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

$Decision = $Host.UI.PromptForChoice($Message, $Question, $Choices, 0)

if ($Decision -eq 0) {
  
  # Capture users groups
  Try {
    # Create Folder for User
    $Folder = New-Item "$Path/$($user.DisplayName)" -ItemType Directory
    
    
    #$Folder = New-Item "//SANCFSINO1/DATA/CSS/DOCS/SEPARATIONS/$(GET-DATE -UFormat %Y)/$User.DisplayName" -ItemType Directory
    
    # Get Group Membership for user and export to csv file
    $ADgroups = Get-ADPrincipalGroupMembership $User.SamAccountName |
    Select Name |
    Export-CSV "$Folder/Groups.csv" -notype
  }
  Catch {
    Break
  }
  
  
}