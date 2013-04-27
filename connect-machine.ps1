param(
#等待的时间是10分钟
[int]$waittime=10,
[string]$status="waiting",#connecting,connected,disconnected
[Parameter(Mandatory=$true, Position = 0)]
[string]$machinename
)

#改变工作目录
Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. .\config.ps1
& .\sync-db.ps1 -nopush

$request="$DB_PATH\$MACHINE_UUID\request.txt"

if !(Test-Path $request){
	New-Item -Path $request -ItemType "File"
}

$m = Select-String -Path $request -Pattern "^$machinename(.*)(disconnected)`$" -NotMatch
if($m -eq $null){
	switch $status{
		"waiting" { "{0}`t{0}`t{0}" -f $machinename,$waittime,$status >> $request }
		"connecting" {}
		"connected"
		"disconnected"
	}
	
}



Pop-Location

