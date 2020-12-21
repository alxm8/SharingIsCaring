
#$user = Get-ADUser -filter * | where Name -like 'alex smith' -Verbose #get AD user with specific name
#Get-ADPrincipalGroupMembership $user | select name # see which AD groups the user is in already
$basedir =  read-host "enter the path of the folder you wish to view ACLs for" #base directory used to find access rights for files and folders
$basedirchilditems = get-childitem -Path $basedir  #get all child items such as files and folders within this folder 
$acllist = @()
foreach($item in $basedirchilditems){
    $itemacls = $null
    $itemacls = (get-acl $item.fullname).access
    $itemacls | Add-Member -Name itempath -MemberType NoteProperty -Value $item.fullname
    $acllist += $itemacls
}

$basedirrecursivechilditems = get-childitem -Path $basedir -Recurse
$recursiveacllist = @()
foreach($item in $basedirrecursivechilditems){
    $itemacls = $null
    $itemacls = (get-acl $item.fullname).access # getting the access acl property for the acl
    $itemacls | Add-Member -Name itempath -MemberType NoteProperty -Value $item.fullname #adding the path of the object to the access object
    $recursiveacllist += $itemacls #adding the new object to the list
}
