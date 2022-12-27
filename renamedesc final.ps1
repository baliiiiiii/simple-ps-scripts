#These scripts have been modified to have some pseudocodey parts. I've removed
#as little as possible to keep it as accurate as I can while still maintaining security.
#I didn't know of invoke-command yet as well! 

#This shell script is for renaming computer descriptions automatically without using Active Directory.
#It requires the Active Directory module of PowerShell, which requires RSAT. 

#this line is for loaner laptop + MANAGERS's computer + my computer
#$COMPUTERS = Get-ADComputer -Filter "Name -like 'MANAGERCOMPUTER' -or Name -like 'MANAGERCOMPUTER' -or Name -like 'MANAGERCOMPUTER' -or Name -like 'MANAGERCOMPUTER'" | Select-Object -ExpandProperty Name


#this line is for all pcs in our ou
$COMPUTERS =  Get-ADComputer -Filter * -SearchBase "TOPLEVELOU" -SearchScope 2 | Select-Object -ExpandProperty Name
$selfUserExclude = (Get-CimInstance -ClassName Win32_ComputerSystem).Username

forEach($i in $COMPUTERS){
	write-host Beginning Connection...
	New-PSSession $i -ErrorVariable failedconnect -WarningAction SilentlyContinue
		if(!($failedconnect)){
			write-host Made connection to $i ...
			Enter-PSSession $i
			#this block of code is for identifying user despite lack of AD -- it accesses security event logs to do this 
			$xmlFilter = @"
				<QueryList>
					<Query Id="0" Path="Security">
						<Select Path="Security">*[System[Provider[@Name='Microsoft-Windows-Security-Auditing'] and (EventID=4624 or EventID=4648)]]
							and *[EventData[Data[@Name='TargetUserName']!='SYSTEM'
								]]
							and *[EventData[Data[@Name='TargetUserName']!='svc.jedi'
								]]
						</Select>
					</Query>
			</QueryList>
"@
			$lastUser = Get-WinEvent -FilterXML $xmlFilter 
			$test = $lastUser | Select @{N='User';E={$_.Properties[5].Value}} -Unique
			$serviceTag = Get-WmiObject -ComputerName $i -class win32_bios | Select-Object -ExpandProperty SerialNumber
			write-host $serviceTag
			write-host $lastUser
			Exit-PSSession
			#temporary lines!! for comparing users
			$i | Out-File -FilePath C:\Users\USERNAME\Desktop\test3.txt -Append 
			$test | Out-File -FilePath C:\Users\USERNAME\Desktop\test3.txt -Append 
			Clear-Variable -name "lastUser"
			Clear-Variable -name "xmlFilter"
			write-host Left $i and wrote unique users locally
			Remove-PSSession *
		}else{
			write-host Connection failed! 
		}
		
}

#generate a report of what computer's descriptions were changed

#check if computer already has description and do not rewrite if so

#specify timeout time param

#specify OUs with ISE (may be quite difficult but would make applicable to everything)

#maybe check with pings before new-pssession in order to be more effciently checking if PC is online?
#MANAGERPC KELVIN
#MANAGERPC LOANER LAPTOP
#authentication might be required within pssession
#For more information about WinRM configuration, run the following command: winrm help config. For more information, see the about_Remote_Troubleshooting Help topic. [PC] Connecting to remote server PC failed with the following error message : WinRM cannot process the request. The following error with errorcode 0x80090322 occurred while using Kerberos authentication: An unknown security error occurred.
#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/new-pssessionoption?view=powershell-7.2 this is more configuration for pssession