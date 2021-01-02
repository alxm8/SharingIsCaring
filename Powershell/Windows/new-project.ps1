#creates a credstore in your home user folder with the below structure

# tree /f
#Folder PATH listing
#C:.
#└───mm-YYYY-tech-project
#    │   tech-project-projectplan.md
#    │
#    ├───binaries
#    ├───diagrams
#    ├───documentation
#    ├───scriptinputs
#    ├───scriptoutputs
#    └───scripts
#create project folder
if ((Test-Path ($home + '\projects\')) -eq $false) {
    mkdir ($home + '\projects\') #create base project folder if it doesnt exist"
    $path = ($home + '\projects\')
    Write-Host "creating projects folder in $path"
    }
$date = get-date -Format "MM-yyyy"
$projectname = read-host "enter the name of the project you want to create with the structure Technology-ProjectName for example AWS-CreatingInstances"
$projectfoldername = ($date + '-' + $projectname)
$projectfoldernamepath = ($home + '\projects\' + $projectfoldername)
if ((Test-Path ($projectfoldernamepath)) -eq $false) {
    mkdir ($projectfoldernamepath) #creates project folder"
    Write-Host "creating project folders and files within $projectfoldernamepath"
    mkdir -Path ($projectfoldernamepath + '\' + 'documentation')
    mkdir -Path ($projectfoldernamepath + '\' + 'scripts')
    mkdir -Path ($projectfoldernamepath + '\' + 'scriptoutputs')
    mkdir -Path ($projectfoldernamepath + '\' + 'scriptinputs')
    mkdir -Path ($projectfoldernamepath + '\' + 'diagrams')
    mkdir -Path ($projectfoldernamepath + '\' + 'binaries')
    New-Item -path $projectfoldernamepath  -Name  ($projectname + '-projectplan.md')
}
