#--module requirements
#1 import-excel - for exporting data
#2 netapp powershell toolkit - for connecting to netapp apis
#3 vmware powercli  - for connecting to vmware apis
#4 credential manager - for accessing credentials for infra objects
#5 veeam pssnapin - for checking backups
#--script overview
#connects to the vcenter and netapp to generate a list of VMs and netapp volumes for AMS DC, checks the list against VEEAM to confirm all devices are backed up.
$vcenter = 'vcentername'
$netappclustername = 'ntpcluster'
$veeamserver = ''
try{connect-viserver $vcenter -credential (Get-StoredCredential -Target admcred)}#log into vcenter
catch{"check your used credentials for $vcenter"}
$tagcat = Get-TagCategory -Name 'Backup Policy' #get the backup policy tag category
$vmobjs = get-vm #get list of vm objects in the vcenter
$backupobjects = $vmobjs | select-object ` #building vm backup configuration
                @{n='BackupPolicy';e={(get-tagassignment -entity $_ -Category $tagcat).tag.name.tostring()}},name,id,`
                @{n='Datacenter';e={get-datacenter -vm $_.name}},`
                @{n='ObjectType';e={$_.ExtensionData}}
try{connect-nccontroller -name $netappclustername -credential (Get-StoredCredential -Target admcred)}#log into amsnetapp
catch{"check your used credentials for $netappclustername"}
$ntpvols = get-ncvol #get a list of volumes on the netapp
$backupserversession = New-PSSession -ComputerName SRVBCKVBR01P -Credential (get-storedcredential -Target alxadmcred)
Invoke-Command $backupserversession{Add-PSSnapin VeeamPSSnapin;Connect-VBRServer;$jobs = Get-VBRJob;}
$backupjobs = Invoke-Command $backupserversession{foreach($job in $jobs){ $job | Select-Object @{Name='jobobjects';Expression={ (get-vbrjobobject $_).name}},name,Jobtype}}
