#if statement to check if the PS7 Profile exists, if not it creates the required folder and file and opens the file
(test-path($home  + '\Documents\Powershell\')) ? "Folder Already Exists" : (New-item -path ($home + '\Documents\Powershell\') -type "directory");
(test-path $profile ) ? "Profile Already Exists" : (New-item -path ($profile) -type "file");
ii $profile;
