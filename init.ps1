. ./config.ps1
. ./machine.ps1

Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd


Write-Host $DB_PATH
#检查存放数据的repo是否下载，如果没下载则下载下来
If (-not (Test-Path $DB_PATH)){
    new-item -path $DB_PATH -itemtype "directory" -force
}
$repo_dir = (Resolve-Path $DB_PATH).Path 
$repo_dir = $repo_dir -replace '\\','/'
Write-Host $repo_dir
$repo_git_dir = $repo_dir + "/.git";
If (-not (Test-Path $repo_git_dir)){
	$git_cmd = "git clone $DB_REPO $repo_dir"
}else{
	$git_cmd = "git --git-dir=$repo_git_dir pull origin master" 
}

Write-Debug $git_cmd
sh --login -c "$git_cmd"
#检查是否是第一次运行此程序
$RUN_TIME = $RUN_TIME+1
.\setconfig.ps1 'RUN_TIME' $RUN_TIME
if ($RUN_TIME -le 1){
	create_machine $DB_PATH $MACHINE_NAME
}


Pop-Location

