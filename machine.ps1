function set_config_value($config, $key, $value){
	$uuid = [System.Guid]::NewGuid().toString();
	if ((Select-String -Path $config -Pattern $key).Matches.Count -gt 0){
		get-content -path $config | %{$_ -replace "$key=.*","$key=$value"} > ".\$uuid.tmp"
		Remove-Item -Path $config
		Move-Item -Path ".\$uuid.tmp" -Destination $config
	}else{
		$tmpstr = "`${0}=`"{1}`"" -f $key, $value
		Write-Output $tmpstr >> $config
	}
}
function find_uuid_by_name($repo, $name){
    $machinconfig = $repo+"\*\config"; 
    $pattern = "name="+$name;
    $config_file_path = select-string -path $machinconfig -pattern $pattern | select-object -property Path
    write-debug $config_file_path 
    $matches = select-string -path $config_file_path.path -pattern "uuid=(.*)"
    write-debug $matches
    $uuid = $matches.matches[0].groups[1]
    return $uuid
}
function write_machine_info($config_file, $uuid, $name){
    $info = "uuid=`"{0}`"`r`n"
    $info +="name=`"{1}`"`r`n"
    $hostname = "{0}.{1}" -f $env:COMPUTERNAME, $env:USERDNSDOMAIN
    $info += "hostname=`"{2}`""
    $info = $info -f $uuid, $name, $hostname
    write-output -inputobject $info >> $config_file
}

function create_machine_ex($repo, $uuid, $name){
    $uuid_dir = $repo+"\"+$uuid;
    $uuid_config_dir = $uuid_dir + "\config"
    $uuid_report_dir = $uuid_dir + "\report.log"
    new-item -path $uuid_dir -itemtype "directory"
    new-item -path $uuid_config_dir,$uuid_report_dir  -itemtype "file"
    write_machine_info $uuid_config_dir  $uuid  $name
}
function create_machine($repo, $name){
	$uuid = [System.Guid]::NewGuid().toString()
	create_machine_ex $repo  $uuid  $name | Out-Null
	Write-Output $uuid;
}
function get_public_ip(){
    $r = [System.Net.WebRequest]::Create("http://www.ip.cn/getip.php?action=getip&ip_url=&from=web")
    $resp = $r.GetResponse()
    $reqstream = $resp.GetResponseStream()
    $sr = new-object System.IO.StreamReader $reqstream
    $result = $sr.ReadToEnd()
    $matchinfo = select-string -inputobject $result -pattern "(\d+\.\d+\.\d+\.\d+)"
    $ip = $matchinfo.matches[0].groups[1];
    return $ip;
}
function get_local_ip(){
	$ips = get-wmiobject -class win32_networkadapterconfiguration -filter ipenabled=TRUE -computername . | select-object @{name="ipaddress";expression={$_.ipaddress[0]}}
	$lip =""
	foreach ($ip in $ips){
		$lip += $ip.ipaddress+","
	}
	$lip = $lip.trim(",")
	return $lip

}
. .\get-internet-time.ps1
function report_status($report_path){	
	$time = Get-InternetTime
	$public_ip = get_public_ip
	$local_ip  = get_local_ip
	$status = "[$time]`t$public_ip`t$local_ip"
	Write-Debug $status
	Write-Output  $status >> "$report_path"
}

function push_data($repo){
	$repo_dir = $repo
	$repo_dir = $repo_dir -replace '\\','/'
	Write-Debug $repo_dir
	$repo_git_dir = $repo_dir + "/.git";
	$git_cmd = "while true do done"
	Write-Debug $git_cmd
	sh --login -c "$git_cmd"
}
function get_internet_time(){
	Get-InternetTime;
}
#find_uuid_by_name $DB_PATH "liu"
#create_machine $DB_PATH "uuu-uuu" "liu"
#get_out_ip