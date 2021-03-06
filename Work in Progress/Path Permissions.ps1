# needs to be run on Pwershell v3.0 or higher

# Validate Active Directory commands exist or import if needed
if (Get-Command Get-ADUser -erroraction 'silentlycontinue'){}
else {
    Import-Module ActiveDirectory
}

$Path = "\\sancfs001\wcc\liens"
$Folder = $Path
$FolderPath = Get-ChildItem -Path "$Path" -Directory -Recurse -Force

$Output = @()

#Root Folder
$Acl = Get-Acl -Path $Folder
ForEach ($Access in $Acl.Access) {
    $Properties = [ordered]@{'Folder Name'=$Folder;'Group/User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
    $Output += New-Object -TypeName PSObject -Property $Properties            
}

# Nested Folders    
ForEach ($Folder in $FolderPath) {
    $Acl = Get-Acl -Path $Folder.FullName
    ForEach ($Access in $Acl.Access) {
        $Properties = [ordered]@{'Folder Name'=$Folder.FullName;'Group/User'=$Access.IdentityReference;'Permissions'=$Access.FileSystemRights;'Inherited'=$Access.IsInherited}
        $Output += New-Object -TypeName PSObject -Property $Properties            
    }
}

$Output | Out-GridView