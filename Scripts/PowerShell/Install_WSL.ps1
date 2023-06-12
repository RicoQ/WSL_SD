$DistributionName = $args[0]
$Username = $args[1]
$UserPassword = $args[2]

$Script=@"
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart;
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart;
wsl --install $DistributionName; 
"@

Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$Script; Start-Sleep -Seconds 1`""
