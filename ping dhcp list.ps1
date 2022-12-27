#These scripts have been modified to have some pseudocodey parts. I've removed
#as little as possible to keep it as accurate as I can while still maintaining security.



$dhcpcomputers = Get-DhcpServerv4Lease -ComputerName DHCPSERVER -Scope DHCPSCOPE | Select-Object HostName, IPAddress
$failure1 = "Ping off Hostname Failed!"
$failure2 = "Ping off IP Failed!"
$linebreak = "`n"
forEach($i in $dhcpcomputers){
	$pingable = Test-Connection $i.hostname -errorvariable fail1
	$pingable2 = Test-Connection $i.ipaddress -errorvariable fail2
	if(!($fail1)){
		$i.hostname | out-file .\pingable.txt -append
		$pingable.pscomputername | out-file .\pingable.txt -append
		$linebreak | out-file .\pingable.txt -append

	}elseif($fail1){
		$i.hostname | out-file .\pingable.txt -append
		$failure1 | out-file .\pingable.txt -append
		$linebreak | out-file .\pingable.txt -append
	}
	if(!($fail2)){
		$i.ipaddress | select-object -property IPAddressToString | out-file .\pingable.txt -append
		$pingable2.ipv4address | out-file .\pingable.txt -append
		$linebreak | out-file .\pingable.txt -append

	}elseif($fail2){
		$i.ipaddress | select-object -property IPAddressToString | out-file .\pingable.txt -append
		$failure2 | out-file .\pingable.txt -append
		$linebreak | out-file .\pingable.txt -append
	}
}