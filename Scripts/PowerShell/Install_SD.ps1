$DistributionName = $args[0]
$Username = $args[1]

$Script=@"
wsl -d $DistributionName -u $Username --cd ~/; 
"@

Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$Script; Start-Sleep -Seconds 60`""