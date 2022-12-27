#These scripts have been modified to have some pseudocodey parts. I've removed
#as little as possible to keep it as accurate as I can while still maintaining security.

#This just filters eventlog. :)

$xmlFilter = @"
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">*[System[Provider[@Name='Microsoft-Windows-Security-Auditing']
and (EventID=4624)
]]
and *[EventData[Data[@Name='TargetUserName']!='SYSTEM'
]]
and *[EventData[Data[@Name='TargetUserName']!='svc.jedi'
]]
   </Select>
  </Query>
</QueryList>
"@

Get-WinEvent -FilterXML $xmlFilter | Select @{N='User';E={$_.Properties[5].Value}} -Unique | where-object {$_.User -notlike "*-*" -and $_.User -notlike "STARTOFCOMPUTERNAMES*"}

#.\winevent.ps1 | Select @{N='User';E={$_.Properties[5].Value}}
#outfile
#filter off of (START OF COMPUTERNAMES)* -- all usernames are lowercase. don't forget AD accounts. DWM* as well.