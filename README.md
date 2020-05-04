# Dank Powershell 7 Setup

This is the cheeky guide you need to follow for a badass Powershell 7 deployment on a new client.

## Getting Started

This guide will get you started with the below:

* [Powershell 7 ](https://github.com/PowerShell/powershell/releases) #new shiny shell with usefull functions.
* [scoop](https://scoop.sh/) #usefull commandline utilities
* [chocolately](https://chocolatey.org/) #windows package manager for easy installation of software
* [Windows Terminal](https://github.com/microsoft/terminal) # Windows new shell installation and customisation
* Windows $Profile and Functions


### Prerequisites

Internet Access
Local Administrator


## Installing Powershell 7

First step is to download that new juicy powershell with ye olde powershell and run the installer.
Cop the below into a powershell window this will download powershell 7.

```
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
Invoke-WebRequest -Uri 'https://github.com/PowerShell/PowerShell/releases/download/v7.0.0/PowerShell-7.0.0-win-x64.msi' -OutFile ($home +'\downloads\PowerShell-7.0.0-win-x64.msi');
ii ($home +'\downloads\);
```
## Installing scoop

Scoop can be installed by running the below command;
```
Set-ExecutionPolicy RemoteSigned -scope CurrentUser;iwr -useb get.scoop.sh | iex

```
###Usefull scoop utilities;
```
scoop bucket add extras
scoop install sudo
scoop install 7zip
scoop install aria2
scoop install concfg
scoop install curl
scoop install dark
scoop install ffsend
scoop install git
scoop install http-downloader
scoop install innounp
scoop install openssh
scoop install openssl
scoop install ffsend
scoop install speedtest-cli
```
## Installing chocolately

Chocolately can be installed by running this command;

```
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
```
###Chocolately usefull apps 
```

choco install microsoft-windows-terminal
choco install vscode
choco install notepad++
choco install microsoft-windows-terminal

```

## Windows Terminal
When chocolately if you have not already you can install Windows Terminal with the below;

```
choco install microsoft-windows-terminal
```
### Windows $Profile
Powershell loads a .ps1 file when it is initialised and executes the commands found within the file. This file is called a profile file.
The location of the profile can be found by typing the below command and the Powershell Prompt;
```
$profile
```
It is possible that after a fresh install the PS7 profile is not created. You can check if this file exists in PS7 with the below command, if the file does not exist the file is created.
```
(test-path($home  + '\Documents\Powershell\')) ? "Folder Already Exists" : (New-item -path ($home + '\Documents\Powershell\') -type "directory");
(test-path $profile ) ? "Profile Already Exists" : (New-item -path ($profile) -type "file");
ii $profile;
```
### Windows $Profile Functions
The below functions can be added to the $profile file for various sysadmin tasks.
```
```
