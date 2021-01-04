###-buys eth from a portfolio in coinbase pro at the market rate
##-summary
#swaps GBP for eth at current market value within a specific portfolio
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
$transactionlogfile = "\\share\eth-trade-transactions.xlsx"
$date = get-date -Format "dd-MM-yyyy-HH:mm"
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
#https://docs.pro.coinbase.com/#place-a-new-order
$transaction = New-CoinbaseProMarketOrder -APIKey $CBAPIKey.key  -APISecret $CBAPIKey.Secret  -APIPhrase $CBAPIKey.phrase -Side buy -Size $gbpaccount.balance -ProductID ETH-GBP
Start-Sleep -s 5
$filledtransaction =  Get-CoinbaseProFills -APIKey  $CBAPIKey.key -APISecret $CBAPIKey.Secret -APIPhrase $CBAPIKey.phrase -ProductID ETH-GBP -OrderID $transaction.id
