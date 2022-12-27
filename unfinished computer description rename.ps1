#These scripts have been modified to have some pseudocodey parts. I've removed
#as little as possible to keep it as accurate as I can while still maintaining security.


#This shell script is for renaming computer descriptions automatically without using Active Directory.
#It requires the Active Directory module of PowerShell, which requires RSAT. 

#this line is for all pcs in our ou
$COMPUTERS =  Get-ADComputer -Filter * -SearchBase "OU=TOPLEVELOU" -SearchScope 2 | Select-Object -ExpandProperty Name
$selfUserExclude = (Get-CimInstance -ClassName Win32_ComputerSystem).Username

forEach($i in $COMPUTERS){
	$test = (Get-ADComputer $i -Properties IPv4Address).IPv4Address
	write-host $test `n
	$i | out-file -filePath C:\Users\username\Desktop\ipv4ad.txt -append
	$test | out-file -filePath C:\Users\username\Desktop\ipv4ad.txt -append
	$newline | out-file -filePath C:\Users\username\Desktop\ipv4ad.txt -append
}

