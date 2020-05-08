function Connect-VM {
	param(
		[Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
		[String[]]$ComputerName
	)
	PROCESS {
		foreach ($name in $computername) {
			vmconnect localhost $name
		}
	}
}
function Start-RDP ($computername)
{
    Start-Process "$env:windir\system32\mstsc.exe" -ArgumentList "/v:$computername"
}
function Get-PublicIP
{
    Invoke-RestMethod https://ipv4.ipleak.net/json -TimeoutSec 20
}
function PWG {
    $Password = ([char[]]([char]33..[char]95) + ([char[]]([char]97..[char]126)) + 0..9 | sort {Get-Random})[0..15] -join ''
    write-host 'Generated Random Password....'
    write-host $password
}
function Azure
{
    	Connect-AzAccount
	start-process "chrome.exe" "https://portal.azure.com",'--profile-directory="Default"'
}
function Get-MACVendor ($mac)
{
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $MACVendor = Invoke-RestMethod -Method get -Uri ('https://api.macvendors.com/' + $mac)
        write-host ('Vendor of '+ $MAC +' is ' +$MACVendor)
}
function start-iPerfServer
{
	write-host 'iPerf on this server runs from C:\iPerf'
	write-host 'Download Link for iPerf: https://iperf.fr/download/windows/iperf-3.1.3-win64.zip'
	write-host 'Invoke-WebRequest -Uri "https://iperf.fr/download/windows/iperf-3.1.3-win64.zip" -OutFile ($home + '\downloads\iperf-3.1.3-win64.zip')'
    write-host 'Place iPerf in the client C:\temp\ folder and run C:\temp\iperf-3.1.3-win64\iperf3.exe -c alx-nuc1 -t 20'
	write-host 'Open the TCP and UDP port on the server with the Powershell command:'
	write-host 'new-netfirewallrule -displayname "iPerfAccess" -direction Inbound -action allow -protocol tcp -localport 5201'
    write-host 'https://iperf.fr/iperf-doc.php'
    C:\iPerf\iperf-3.1.3-win64\iperf3.exe iperf -s
}
function New-CredStoreCred {
	
	$credstoreDIR = ($home + '\.credstore\')
	$credstoreCredName = read-host "Enter the Credential Name:"
	$credstoreCredKey = read-host "Enter Password to be encrypted:" -assecurestring | convertfrom-securestring | out-file ($credstoreDIR + $credstoreCredName+'.key')
}

function Get-HostNetworking {

	$netadapters = Get-NetAdapter | select name,ifIndex,InterfaceDescription,MacAddress,status,LinkSpeed | sort Status -Descending
	$MACAddresses = Get-NetNeighbor | where state -ne Permanent | Select-Object InterfaceAlias,InterfaceIndex,IPAddress,LinkLayerAddress,State | sort-object IPAddress
	$IPs = Get-NetIPAddress | select * | select InterfaceAlias,InterfaceIndex,IPAddress,PrefixLength | where IPAddress -NotLike 'fe*' | where IPAddress -NotLike '169*'
	$IPRoutes = get-netroute | where NextHop -NE '0.0.0.0' | where NextHop -NE '::'
	$DNSServers = Get-DnsClientServerAddress | Where-Object ServerAddresses -NotLike '*fe*'
	$TCPSessions = Get-NetTCPConnection | where state -ne Listen | where state -ne Bound
	pause 5

	Write-host "Get-HostNetworking Output for $Env:COMPUTERNAME" -ForegroundColor Blue
	Write-host "Physical Network Adapters on $Env:COMPUTERNAME" -ForegroundColor Blue
	$netadapters | ft -a
	Write-host "MAC Addresses Visible on Network from $Env:COMPUTERNAME" -ForegroundColor Blue
	$MACAddresses| ft -a
	Write-host "IP Addresses on $Env:COMPUTERNAME" -ForegroundColor Blue
	$IPs | ft -a
	Write-host "IP Routes on $Env:COMPUTERNAME" -ForegroundColor Blue
	$IPRoutes | ft -a
	Write-host "DNS servers on $Env:COMPUTERNAME" -ForegroundColor Blue
	$DNSServers | ft -a
	Write-host "TCP Connections on $Env:COMPUTERNAME" -ForegroundColor Blue
	$TCPSessions | ft -a
}
function ggl ($q)
{
	$q = $q -replace '\s','+' 
	$q = ('https://www.google.com/search?q='+ $q )	
    start-process chrome $q
}
function download ($downloadURL)
{
        aria2c $downloadURL -d $downloadDir
        get
}
function functions{

	write-host "Connect-VM -VMName (Open Hyper-V VM Console Window to VMName)" -ForegroundColor Blue
	write-host "Start-RDP -Hostname (RDP to IP or hostname)" -ForegroundColor Blue
	write-host "Get-PublicIP (Get Public IP)" -ForegroundColor Blue
	write-host "PWG (Password Generator)" -ForegroundColor Blue
	write-host "Azure (Connect to Azure Account)" -ForegroundColor Blue
	write-host "Get-MACVendor -MAC (Get the Vendor of a MAC address)"-ForegroundColor Blue
	write-host "start-iPerfServer (Start an iPerf Server)"-ForegroundColor Blue
	write-host "New-CredStoreCred (Create an encrypted key for credstore)"-ForegroundColor Blue
	write-host "Get-HostNetworking (Get local host network configuration)"-ForegroundColor Blue
	write-host "ggl (google it)" -ForegroundColor Blue
	write-host "download -fileurl (download a file with aria2c)" -ForegroundColor Blue
}

$profPublicIP = Get-PublicIP
$profGitDIR = ($home + '\documents\git')
$profCredStore = ($home + '\.credstore')
$profHostFile = 'C:\Windows\System32\Drivers\Etc\hosts'
$profVars = get-variable | Where-Object name -Like 'prof*'
