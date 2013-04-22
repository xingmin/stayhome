#生成本机的唯一标识码
$uuid = [System.Guid]::NewGuid().toString();
get-content -path .\config.ps1 | %{$_ -replace '\$MACHINE_UUID=[" .]*',"`$MACHINE_UUID=`"$uuid`""} > .\$uuid.tmp
Remove-Item -Path .\config.ps1
Move-Item -Path ".\$uuid.tmp" -Destination ".\config.ps1"