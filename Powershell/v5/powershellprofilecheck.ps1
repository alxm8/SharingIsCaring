#checks powershell version is not v7 and creates the powershell profile file.

if ($PSVersionTable -notlike 7) {

    Write-Host "Powershell version is not 7"
    if ((test-path $profile ) -eq $false) {

        New-Item -Path $profile
        Write-Host "creating powershell profile at $profile"
        ii $profile
        
    }else {
        Write-Host "profile file at $profile already exists"
        ii $profile
    }
    
}else {
    write-host "Powershell Version $psversiontable.PSVersion is not compatible"
}

