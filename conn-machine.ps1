[Parameter(Mandatory=$false,parametersetname="ConnectSet")]
param(
#等待的时间是10分钟
[Parameter(Mandatory=$false,parametersetname="ConnectSet")]
[int]$waittime=10,
[Parameter(Mandatory=$true,parametersetname="ConnectSet", Position = 1)]
[string]$status="waiting",#connecting,connected,disconnected
[Parameter(Mandatory=$true,parametersetname="ConnectSet", Position = 0)]
[string]$machinename
)

function chgstat(){
	[CmdletBinding(DefaultParameterSetName = "ChgStatSet")]
	param( [Parameter(Mandatory=$true,parametersetname="ChgStatSet")]
		[string]$machine, 
		[Parameter(Mandatory=$false,parametersetname="ChgStatSet")]
		[int]$wait_time=10,
		[Parameter(Mandatory=$true,parametersetname="ChgStatSet")]
		[string]$stat, 
		[Parameter(Mandatory=$true,parametersetname="ChgStatSet")]
		[string]$req)
	Write-Debug ("machine-{0} wait_time-{1}  stat-{2} re-{3}" -f $machine,$wait_time,$stat,$req)
	if (! (Test-Path $req)){
		echo $null > $req
	}
	$m = Select-String -Path $req -Pattern "^$machine(.*)disconnected`$" -NotMatch
	if($m -eq $null){
		#没有找到本机目前正在连接的机器,可以添加连接请求
		Write-Debug "not found working connection, so fire the connect command."
		"{0}`t{1}`t{2}`t{3}" -f $machine,((get-internettime)),$wait_time,$stat >> $req
	}else{
		#改变正在连接的机器的状态
		Write-Debug "changing the connection's status."
		$uuid = [System.Guid]::NewGuid().toString();
		Get-Content -Path $req | ForEach-Object -Process { $_ -replace "^($machine.*)\b(waiting|connecting|connected)`$","`${1}$stat"} | Out-File -FilePath "$uuid.txt"
		Remove-Item -Path  $req
		Move-Item -Path "$uuid.txt" -Destination $req	
	}
}


#改变工作目录
Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. .\get-internet-time.ps1
. .\config.ps1
& .\sync-db.ps1 -nopush

$request="$DB_PATH\$MACHINE_UUID\request.txt"

chgstat -machine $machinename -stat $status -req $request

#同步数据
& .\sync-db.ps1

Pop-Location

