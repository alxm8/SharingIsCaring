#gather all VMs for Hyper-V Host and Hosts in the same Cluster
write-host "This script will prompt you for the hostname of a Hyper-V Host and gather all of the VMs that exist on the same Microsoft Cluster"
write-host "Hyper-V Powershell Module is required for getting VMs"
Get-Module | where name -eq Hyper-V #checking Hyper-V Module is installed.
$HVNode = Read-Host "Please enter the Hyper-V node name" #prompting user for HV Node Name
$s = New-PSSession -ComputerName $HVNode #creating pssession to hyper-v node
$clusternodes = Invoke-Command -Session $s {get-clusternode} #gathering nodes in cluster
$s | Remove-PSSession #closing pssession
$global:VMs = foreach($node in $clusternodes){get-vm -computername $node.name} #gathering VMs in cluster
Write-Host "VMs in var global:VMs" -ForegroundColor Yellow
$global:VMs | Format-Table -AutoSize