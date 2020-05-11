$vc = Read-Host "Please enter vCenter Name"
Connect-VIServer -Server $vc
$dss = get-datastore 
Write-Host "NFS Datastores"
$dss | where Type -eq 'NFS' | select Name,RemoteHost,RemotePath,State,FileSystemVersion | ft -a
Write-Host "VMFS Datastores and associated naa LUN IDs"
$dss | where Type -eq 'VMFS' | Select Name,Type,@{N="NaaNumber";E={get-scsilun -Datastore $_}}
