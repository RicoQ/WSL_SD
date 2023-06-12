$DistributionName = $args[0]
$user_name = $args[1]
$passwd = $args[2]
$dest_folder = 

Write-Host "Distribution : $DistributionName"
Write-Host "User Name : $user_name"
write-Host "Password : $passwd"


# Retrieve the current Windows username
$whoamiOutput = (whoami).Trim()
$username = if ($whoamiOutput.StartsWith("BUILTIN")) { $whoamiOutput.Split("\")[1] } else { $whoamiOutput }
Write-Host "Windows User Name : $username"

# Grant necessary permissions to the WSL distribution folder
$icaclsCommand = "icacls.exe"
$icaclsArguments = "\\wsl.localhost\$DistributionName" + " /grant `"`${username}``:F /T"

# Prompt for administrative privileges
$processStartInfo = New-Object System.Diagnostics.ProcessStartInfo
$processStartInfo.FileName = $icaclsCommand
$processStartInfo.Arguments = $icaclsArguments
$processStartInfo.Verb = "RunAs"
$processStartInfo.UseShellExecute = $true

try {
    $process = [System.Diagnostics.Process]::Start($processStartInfo)
    $process.WaitForExit()
} catch {
    Write-Host "Failed to run the command with elevated privileges: $_"
    Exit 1
}

# Set the $PSScriptRoot to the WSL_SD directory
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$PSScriptRoot = Split-Path -Parent -Path $PSScriptRoot
$PSScriptRoot = Split-Path -Parent -Path $PSScriptRoot
Write-Host "PS Script Root : $PSScriptRoot"

# Copy .wslconfig file to the user's main folder
$userMainFolder = [Environment]::GetFolderPath('UserProfile')
Write-Host "User main folder : $userMainFolder"
$wslConfigSource = Join-Path -Path $PSScriptRoot -ChildPath 'Configs\.wslconfig'
Write-Host "Win User Config Source : $wslConfigSource"
$wslConfigDestination = Join-Path -Path $userMainFolder -ChildPath '.wslconfig'
Write-Host "Win User Config Destination : $wslConfigDestination"
Copy-Item -Path $wslConfigSource -Destination $wslConfigDestination -Force

# Copy wsl.conf file to the distribution's /etc folder
$wslConfSource = Join-Path -Path $PSScriptRoot -ChildPath 'Configs\wsl.conf'
Write-Host "Linux Config Source : $wslConfSource"
$wslConfDestination = "\\wsl.localhost\$DistributionName\etc\wsl.conf"
Write-Host "Linux Config Destination : $wslConfDestination"

# Find the username by locating the only folder within the "home" directory
$homeFolder = Join-Path -Path "\\wsl.localhost\$DistributionName" -ChildPath 'home'
Write-Host "Linux User Home Folder : $homeFolder" 
#$wsl_user = Get-ChildItem -Path $homeFolder | Select-Object -ExpandProperty Name

# Copy Start_SD.sh file to the user's home folder within WSL
$startSDSource = Join-Path -Path $PSScriptRoot -ChildPath 'Scripts\Bash\Start_SD.sh'
Write-Host "Start SD Source : $startSDSource"
$startSDDestination = Join-Path -Path $homeFolder -ChildPath $user_name
Write-Host "Start SD Destination : $startSDDestination"
Copy-Item -Path $startSDSource -Destination $startSDDestination -Force

# Copy Configure_WSL.sh file to the user's home folder within WSL
$confWSLSource = Join-Path -Path $PSScriptRoot -ChildPath 'Scripts\Bash\1_Configure_WSL.sh'
Write-Host "WSL Conf Source : $confWSLSource"
$ConfWSLDestination = Join-Path -Path $homeFolder -ChildPath $user_name
Write-Host "WSL Conf Destination : $ConfWSLDestination"
Copy-Item -Path $confWSLSource -Destination $ConfWSLDestination -Force

# Copy Configure_WSL.sh file to the user's home folder within WSL
$confCondaSource = Join-Path -Path $PSScriptRoot -ChildPath 'Scripts\Bash\2_Configure_Conda.sh'
Write-Host "Conda Conf Source : $confCondaSource"
$ConfCondaDestination = Join-Path -Path $homeFolder -ChildPath $user_name
Write-Host "Conda Conf Destination : $ConfCondaDestination"
Copy-Item -Path $confCondaSource -Destination $ConfCondaDestination -Force

# Copy Configure_WSL.sh file to the user's home folder within WSL
$InstallSDSource = Join-Path -Path $PSScriptRoot -ChildPath 'Scripts\Bash\3_Install_SD.sh'
Write-Host "SD Install Source : $InstallSDSource"
$InstallSDDestination = Join-Path -Path $homeFolder -ChildPath $user_name
Write-Host "SD Install Destination : $InstallSDDestination"
Copy-Item -Path $InstallSDSource -Destination $InstallSDDestination -Force

# Copy Configure_WSL.sh file to the user's home folder within WSL
$PreSource = Join-Path -Path $PSScriptRoot -ChildPath 'Scripts\Bash\Prep.sh'
Write-Host "SD Pre-Install Source : $PreSource"
$PreDestination = Join-Path -Path $homeFolder -ChildPath $user_name
Write-Host "SD Pre-Install Destination : $PerDestination"
Copy-Item -Path $PreSource -Destination $PreDestination -Force

# Copy Configure_WSL.sh file to the user's home folder within WSL
$SDSource = Join-Path -Path $PSScriptRoot -ChildPath 'Scripts\Bash\SD.sh'
Write-Host "SD Main Source : $SDSource"
$SDDestination = Join-Path -Path $homeFolder -ChildPath $user_name
Write-Host "SD Main Destination : $SDDestination"
Copy-Item -Path $SDSource -Destination $SDDestination -Force

# Copy the file using robocopy with the /B flag to copy files in backup mode
$robocopyCommand = "robocopy.exe"
$robocopyArguments = "`"$wslConfSource`" `"$wslConfDestination`" /B"
Write-Host "Robo Copy Done"

try {
    Start-Process -FilePath $robocopyCommand -ArgumentList $robocopyArguments -Wait -Verb RunAs
} catch {
    Write-Host "Failed to run the command with elevated privileges: $_"
    Exit 1
}

Write-Host "Configuration files copied successfully."

Start-Sleep -Seconds 2 # Pause for verification (adjust the sleep duration as needed)
