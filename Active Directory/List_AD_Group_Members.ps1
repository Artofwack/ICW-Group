# List_AD_Group_Members
# Arturo E Polanco
# 6-29-18

#
# Lists all users in an Active Directory Group. This
# searches subgroups recursively and lists user objects only.
# 

$Path = "C:\users\apolanco\desktop" # "\\sancfs001\public$\apolanco\Scripts\Active Directory\Results"

# Validate Active Directory commands exist
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

# AD Group to look for members of
$Name = Read-Host -Prompt "Input the Group"

# Search in both domains for group
$domains = (Get-ADForest).domains

foreach ($domain in $domains) {
    
    try {
      $Group = $null
      
      $Group = Get-ADGroup -Filter { Name -eq $Name } -Server $domain |
      Select -ExpandProperty DistinguishedName
    
      if ( $Group -ne $null) {           
        Get-ADGroupMember $Group -Recursive -Server $domain |
        Where { $_.objectclass -eq 'user' } |
        Select -ExpandProperty DistinguishedName |
        Get-ADUser -Properties Displayname, EmailAddress, Department, Title, Company, Manager | 
        Select DisplayName, samAccountName, Title, Department, `
        @{Name=”Manager”; Expression={$(get-aduser -identity $_.Manager -Properties DisplayName |
          Select -ExpandProperty DisplayName)}}|
        Sort Manager, DisplayName |
        Export-csv "$Path\$Name members.csv" -NoType
      }
    }
    catch {
      
    }
}

#c:\users\apolanco\desktop\
#DG-PowerBI Pro Users
