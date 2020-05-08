#---------------------------------------------------------[Initialisations]--------------------------------------------------------
# ZVM on Production side used to create VPGs
$ZVMServer = read-host "please enter the resolvable DNS name or IP of the ZVM" #you can use local host if you run the script from the source ZVM.
# Get Credentials to connect to ZVM API
$Credentials = Get-Credential -Message "Please enter Username and Password for ZVM $($ZVMServer)"
$username = $Credentials.UserName
$password = $Credentials.GetNetworkCredential().Password


#-----------------------------------------------------------[Functions]------------------------------------------------------------

function getxZertoSession ($zvm, $userName, $password) {
    $xZertoSessionURL = $zvm+"session/add"
    $authInfo = ("{0}:{1}" -f $userName,$password)
    $authInfo = [System.Text.Encoding]::UTF8.GetBytes($authInfo)
    $authInfo = [System.Convert]::ToBase64String($authInfo)
    $headers = @{Authorization=("Basic {0}" -f $authInfo)}
    $body = '{"AuthenticationMethod": "1"}'
    $contentType = "application/json"
    $xZertoSessionResponse = Invoke-WebRequest -Uri $xZertoSessionURL -Headers $headers -Method POST -Body $body -ContentType $contentType -UseBasicParsing
    return @{"x-zerto-session"=$xZertoSessionResponse.headers.get_item("x-zerto-session")}
}
#-----------------------------------------------------------[Ignore Cert]------------------------------------------------------------
#-Certificates That are not trusted need to be accepted
add-type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
public bool CheckValidationResult(
ServicePoint srvPoint, X509Certificate certificate,
WebRequest request, int certificateProblem) {
return true;
}
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

#-----------------------------------------------------------[Execution]------------------------------------------------------------
#https://s3.amazonaws.com/zertodownload_docs/Latest/Zerto%20Virtual%20Replication%20RESTful%20APIs.pdf
# Build Zerto REST API Url
$ZertoRestURL = "https://$($ZVMServer)/v1/"
# Get Zerto Session Header for Auth
$ZertoSession = getxZertoSession "$($ZertoRestURL)" $username $password

#API calls


$global:SiteInfo = Invoke-RestMethod -Method Get  -Uri ($ZertoRestURL+'localsite') -Headers $ZertoSession
$global:VPGs = Invoke-RestMethod -Method Get  -Uri ($ZertoRestURL+'vpgs') -Headers $ZertoSession
$global:ProtectedVMs = Invoke-RestMethod -Method Get  -Uri ($ZertoRestURL+'vms') -Headers $ZertoSession
$global:UnprotectedVMs = Invoke-RestMethod -Method Get  -Uri ($ZertoRestURL+'virtualizationsites/'+$SiteInfo.SiteIdentifier+'/vms') -Headers $ZertoSession

Write-Host "check global:siteinfo, global:VPGs, global:ProtectedVMs and global:UnprotectedVMs variables for output" -ForegroundColor Yellow