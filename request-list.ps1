

#get all machines's status,name & public ip & local ip & register time etc.
Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. ./config.ps1

select-string -Path "$DB_PATH\*\request.txt"  -pattern "^(B102345.*)\b(waiting|connecting|connected)" `
| Sort-Object @{Expression = { [DateTime]$_.Line.split("`t")[1] };ascending=$true},@{ Expression={[int]$_.Line.split("`t")[2]};ascending=$true } `
| Select-Object -Property `
@{Name="MachineName"; Expression={$x=Split-Path -Path $_.Path -Parent;  $y = Select-String -Path "$x\config" -Pattern '^name="([^"]*)"$'; echo $y.matches[0].groups[1]}}`
,@{Name="MachineUUID"; Expression={$x=Split-Path -Path $_.Path -Parent;  $y = Select-String -Path "$x\config" -Pattern '^uuid="([^"]*)"$'; echo $y.matches[0].groups[1]}}`
,@{Name="MachineIp"; Expression={$x=Split-Path -Path $_.Path -Parent; ((Get-Content -Path "$x\report.log" | Select-Object -Last 1) -split "`t")[1]}}`
,Line

Pop-Location

