#creates a new project folder in your home user folder with the below structure

#C:\USERS\USER\.CREDSTORE
#├───bin
#├───certs
#├───keys
#├───pscredentials
#└───sshkeys
#create .credstore in $home
if ((Test-Path ($home + '\.credstore\')) -eq $false) {
    mkdir ($home + '\.credstore\') #create credstore folder"
    $path = ($home + '\.credstore\')
    Write-Host "creating credstore in $path"
    }else {
        $path = ($home + '\.credstore\')
        Write-Host "credstore already exists at path $path"

}
if ((Test-Path ($home + '\.credstore\certs\')) -eq $false) {
    mkdir ($home + '\.credstore\certs\') #create credstore certs folder"
    $path = ($home + '\.credstore\certs\')
    Write-Host "creating credstore cert folder in $path"
    }else {
        $path = ($home + '\.credstore\certs\')
        Write-Host "credstore cert folder already exists at path $path"

}
if ((Test-Path ($home + '\.credstore\keys\')) -eq $false) {
    mkdir ($home + '\.credstore\keys\') #create credstore keys folder"
    $path = ($home + '\.credstore\keys\')
    Write-Host "creating credstore keys folder in $path"
    }else {
        $path = ($home + '\.credstore\keys\')
        Write-Host "credstore keys folder already exists at path $path"

}
if ((Test-Path ($home + '\.credstore\pscredentials\')) -eq $false) {
    mkdir ($home + '\.credstore\pscredentials\') #create credstore pscredential folder"
    $path = ($home + '\.credstore\pscredentials\')
    Write-Host "creating credstore pscredentials in $path"
    }else {
        $path = ($home + '\.credstore\pscredentials\')
        Write-Host "credstore pscredentials already exists at path $path"

}
if ((Test-Path ($home + '\.credstore\bin\')) -eq $false) {
    mkdir ($home + '\.credstore\bin\') #create credstore folder"
    $path = ($home + '\.credstore\bin\')
    Write-Host "creating credstore bin in $path"
    }else {
        $path = ($home + '\.credstore\bin\')
        Write-Host "credstore bin already exists at path $path"

}
if ((Test-Path ($home + '\.credstore\sshkeys\')) -eq $false) {
    mkdir ($home + '\.credstore\sshkeys\') #create credstore sshkeys folder"
    $path = ($home + '\.credstore\sshkeys\')
    Write-Host "creating credstore sshkeys in $path"
    }else {
        $path = ($home + '\.credstore\sshkeys\')
        Write-Host "credstore sshkeys already exists at path $path"

}
