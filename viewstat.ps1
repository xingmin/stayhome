#get all machines's status,name & public ip & local ip & register time etc.
Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. ./config.ps1

Get-ChildItem -Path "$DB_PATH" |`
Where { ($_.GetType() -eq [System.IO.DirectoryInfo]) -and ($_.Name -match "[a-f 0-9]{8}-([a-f 0-9]{4}-){3}[a-f 0-9]{12}")}`
| ForEach-Object -Process { `
$x = Select-String -Path ($_.FullName+"\config") -Pattern '^name="(.*)"'; `
$y=Get-Content -Path ($_.FullName+"\report.log") | Select-Object -Last 1; `
$y = $y.split("`t");`
("{0}`t{1}`t{2}`t{3}" -f  $x.matches[0].groups[1],$y[1].trim(),$y[2].trim(),$y[0].trim()) | Write-Host  } 

Pop-Location