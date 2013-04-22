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
    $info = "uuid={0}`r`n"
    $info +="name={1}`r`n"
    $hostname = "{0}.{1}" -f $env:COMPUTERNAME, $env:USERDNSDOMAIN
    $info += "hostname={2}"
    $info -f $uuid, $name, $hostname
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
	create_machine_ex $repo  $uuid  $name
}
function get_out_ip(){
    $r = [System.Net.WebRequest]::Create("http://iframe.ip138.com/ic.asp")
    $resp = $r.GetResponse()
    $reqstream = $resp.GetResponseStream()
    $sr = new-object System.IO.StreamReader $reqstream
    $result = $sr.ReadToEnd()
    $matchinfo = select-string -inputobject $result -pattern "(\d+\.\d+\.\d+\.\d+)"
    $ip = $matchinfo.matches[0].groups[1];
    return $ip;
}
#function report_status($repo, $uuid)

#find_uuid_by_name $DB_PATH "liu"
#create_machine $DB_PATH "uuu-uuu" "liu"
#get_out_ip