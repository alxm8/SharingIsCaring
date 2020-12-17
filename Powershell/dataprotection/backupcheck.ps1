###--script overview
#connects to the vcenter and netapp to generate a list of VMs and netapp volumes for AMS DC, checks the list against VEEAM to confirm all devices are backed up.
###--module requirements
#1 import-excel - for exporting data
#2 netapp powershell toolkit - for connecting to netapp apis
#3 vmware powercli  - for connecting to vmware apis
#4 credential manager - for accessing credentials for infra objects
#   make sure you have a credential that exists with adm creds called admcred (New-StoredCredential -Target admcred -Persist LocalMachine -Credentials (get-credential))
#5 veeam pssnapin - for checking backups
###environmental variables
$vcentername = ''
$netappname = ''
$veeamservername = ''
$storedcredentials = (Get-StoredCredential -Target admcred)
$datacentername  = ''
###connecting to devices
write-host "connecting to $vcentername" -ForegroundColor Yellow
try{connect-viserver $vcentername -credential $storedcredentials | Out-Null}#log into vcenter
catch{"check your used credentials for $vcentername"}
write-host "connecting to $netappname" -ForegroundColor Yellow
try{connect-nccontroller -name $netappname -credential $storedcredentials | Out-Null}#log into amsnetapp
catch{"check your used credentials for $netappname"}
# create powershell session to veeam server
###VMWare VM Information
write-host "gathering backup information....this may take some time" -ForegroundColor Blue
write-host "connecting to $veeamservername" -ForegroundColor Yellow
$backupserversession = New-PSSession -ComputerName $veeamservername  -Credential $storedcredentials
Invoke-Command $backupserversession {Add-PSSnapin VeeamPSSnapin;Connect-VBRServer;$jobs = Get-VBRJob;} # add the veeam powershell commands to the powershell session and gather a list of backup jobs
$backupjobs = Invoke-Command $backupserversession{foreach($job in $jobs){ $job | Select-Object @{Name='jobobjects';Expression={ (get-vbrjobobject $_).name}},name,Jobtype}} #for each backup job get the objects in the job
write-host "gathering vm information....this may take some time" -ForegroundColor Blue
$tagcat = Get-TagCategory -Name 'Backup Policy' #get the backup policy tag
$vmobjs = get-datacenter $datacentername | get-vm #get list of vm objects
$vmbackupobjects = $vmobjs | select-object `
                @{n='BackupPolicyTag';e={(get-tagassignment -entity $_ -Category $tagcat).tag.name.tostring()}},name,`
                @{n='Datacenter';e={(get-datacenter -vm $_.name).tostring()}},`
                @{n='ObjectType';e={("VMWare.VM")}},`
                @{n='AssociatedVEEAMBackupPolicies';e={$null}}  
                #building backup tag objects
write-host "gathering volume information....this may take some time" -ForegroundColor Blue
$volbackupobjects = get-ncvol | where name -like *CIFS* #get a list of volumes on the netapp
$volbackupobjects = $volbackupobjects  | Select-Object `
                @{n='BackupPolicyTag';e={'None'}},name,`
                @{n='Datacenter';e={'AMS0'}},`
                @{n='ObjectType';e={'Netapp.Volume'}},`
                @{n='AssociatedVEEAMBackupPolicies';e={$null}}  

write-host "comparing vms and vols against backup content" -ForegroundColor Blue
foreach($obj in $vmbackupobjects){ # for each backup objects find the jobs which the object is included within

    $obj.AssociatedVEEAMBackupPolicies = ($backupjobs | where-object jobobjects -like $obj.name).name -join ','
    if ($obj.BackupPolicyTag -eq 'Platinum' ) {
        $obj.AssociatedVEEAMBackupPolicies = 'VMW - Platinum'
    }
    if ($obj.BackupPolicyTag -eq 'Gold' ) {
        $obj.AssociatedVEEAMBackupPolicies = 'VMW - Gold'
    }
    if ($obj.BackupPolicyTag -eq 'Silver' ) {
        $obj.AssociatedVEEAMBackupPolicies = 'VMW - Silver'
    }
}
foreach($volobj in $volbackupobjects){ # for each backup objects find the jobs which the object is included within
    $volobj.AssociatedVEEAMBackupPolicies = ($backupjobs | where-object Name -like ('*'+$volobj.name+'*')).name
}
write-host ("outputting information to "+ $scriptoutputdir) -ForegroundColor Blue
$date = get-date -Format "dd-MM-yyyy-HH-mm"
$vmbackupfilename = '-vmbackupobjects.xlsx'
$volbackupfilename = '-volbackupobjects.xlsx'
$scriptoutputdir = '\\share\folder\'
$vmbackupobjects |Export-Excel -path ($scriptoutputdir+$date+$vmbackupfilename) -TableName 'vmbackupobjects'
$volbackupobjects |Export-Excel -path ($scriptoutputdir+$date+$volbackupfilename) -TableName 'volbackupobjects'
