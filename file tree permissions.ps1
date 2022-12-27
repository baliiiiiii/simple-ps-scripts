#These scripts have been modified to have some pseudocodey parts. I've removed
#as little as possible to keep it as accurate as I can while still maintaining security.

#This one was for automatically pulling a list of usernames, creating a file tree with each folder
#being labelled their username, and giving each user rights to their respective folder.

#script for auto making file server dir with all users + permissions
#adjust in future to allow for user input to allow for: select path of creation of file, what user it's being created for, and what user's rights are being assigned
#test-path will allow for complete ability to be ran if above is followed as well

$Users =  Get-ADUser -Filter * -SearchBase "TOPLEVELOU" -SearchScope 2 | select -expandproperty SamAccountName 
$filePath = "C:\users\USERNAME\desktop\dump folder\test"

foreach($i in $Users){
	#create directory path for acl
	$aclPath = Join-Path -path $filePath -childPath $i
	#test for path
	$test = test-path -path $aclPath
	
	if(!$test){
		#create directory
		new-item -path $filePath -name $i -item	Type directory
		#create acl to be modified based off freshly created dir
		$NewAcl = Get-Acl -Path $aclPath
		#Set properties
		$identity = $i
		$fileSystemRights = "Modify"
		$type = "Allow"
		$InheritanceFlag = "ContainerInherit,ObjectInherit"	
		#Create new rule
		$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $InheritanceFlag, 'None', $type 
		$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
		#Apply new rule
		$NewAcl.SetAccessRule($fileSystemAccessRule)
		Set-Acl -Path $aclPath -AclObject $NewAcl
		}
}