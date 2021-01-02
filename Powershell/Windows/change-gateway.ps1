#swap default gateway from home router to VPN tunnel
$route = get-netroute -DestinationPrefix "0.0.0.0/0"

if ($route.NextHop -eq "192.168.1.1") {
    remove-netroute -ifindex $route.ifIndex -DestinationPrefix $route.DestinationPrefix -NextHop $route.NextHop -confirm:$false 
    New-NetRoute -Ifindex $route.ifindex -DestinationPrefix $route.DestinationPrefix -NextHop "192.168.1.254" -confirm:$false
}else{
    remove-netroute -ifindex $route.ifIndex -DestinationPrefix $route.DestinationPrefix -NextHop $route.NextHop -confirm:$false
    New-NetRoute -Ifindex 9 -DestinationPrefix "0.0.0.0/0" -NextHop "192.168.1.1" -confirm:$false
}
Get-NetRoute -DestinationPrefix 0.0.0.0/0
