#get all machines's status,name & public ip & local ip & register time etc.
Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. ./config.ps1

select-string -Path ".\*\request.txt"  -pattern "^(B102345.*)\b(waiting|connecting|connected)" `
|select-object -property Line `
| Sort-Object @{Expression = { [DateTime]$_.split("`t")[1] };ascending=$true},@{ Expression={[int]$_.split("`t")[2]};ascending=$true }xc.xc..x.x.xcvd

Pop-Location