###-market rate of crypto
##-summary
#gets market rate for BTC and ETH
##-prerequisites - modules
#Install-Module -Name CoinbasePro-Powershell
#Install-Module -Name ImportExcel
##-prerequisites-choco
#Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#- choco install bitwardencli -y 
#when installed the files are located in Directory: C:\Program Files\WindowsPowerShell\Modules
#setup
#get-command -module CoinbasePro-Powershell #list of commands in the powershell module
#api keys are created at this web url https://pro.coinbase.com/profile/api
#create a new credential called 'coinbase pro quickportfoliotradingkey' in bitwarden with the fields APISecret,keyID & Passphrase
#use the above link in coinbase pro to create an api key for secure communication with the API, ensure you can buy and sell crypto and lock down to your IP
#retrieve your public IP with this command; curl https://ipinfo.io/
#
#test connectivity to bitwarden with the below commands
#bw login 
#bw unlock
#bw list items --search 'coinbase pro quickportfoliotradingkey'
#$keyid = bw list items --search 'coinbase pro quickportfoliotradingkey' | ConvertFrom-Json;$keyid = $key.id
#(bw get item 91ee30f5-5170-4e7b-862d-aca600c57663 | ConvertFrom-Json | select fields -ExpandProperty fields | where name -eq APISecret |select value).value
$CredentialObject = bw get item 91ee30f5-5170-4e7b-862d-aca600c57663 | ConvertFrom-Json | select fields -ExpandProperty fields #get the API key object from bitwarden used to connect to coinbase
$APISecret = ($CredentialObject | where name -eq APISecret | select value).value #extract the APISecret from the credential object
$APIKey = ($CredentialObject | where name -eq keyID | select value).value  #extract the KeyID from the credential object
$APIPassphrase = ($CredentialObject | where name -eq Passphrase | select value).value #extract the Passphrase from the credential object

$CBAPIKey = [PSCustomObject]@{
    Key = "$APIKey";
    Secret = "$APISecret";
    Phrase = "$APIPassphrase";      
}#build a credential object used by powershell to connect to coinbase
$ethaccount = Get-CoinbaseProAccounts -APIKey $CBAPIKey.key -APISecret $CBAPIKey.Secret -APIPhrase $CBAPIKey.phrase | where currency -eq ETH #get the ETH Wallet balance of the account linked to the APIKey
$gbpaccount = Get-CoinbaseProAccounts -APIKey $CBAPIKey.key -APISecret $CBAPIKey.Secret -APIPhrase $CBAPIKey.phrase | where currency -eq GBP #get the GBP Wallet balance of the account linked to the APIKey
Write-Host "gbp balance in quick portfolio " -ForegroundColor yellow
$gbpaccount | ft -a #output the balance of GBP
Write-Host "eth balance in quick portfolio " -ForegroundColor yellow
$ethaccount | ft -a #output the balance of ETH
Write-Host "eth current value on coinbase" -ForegroundColor yellow
Get-CoinbaseProProductStats -ProductID ETH-GBP #output the current market price of ETH to GBP
