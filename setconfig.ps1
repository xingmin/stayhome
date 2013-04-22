$key = $args[0]
$value = $args[1]
Write-Host $key $value "$key=[`" .]*"
#生成本机的唯一标识码
$uuid = [System.Guid]::NewGuid().toString();
get-content -path .\config.ps1 | %{$_ -replace "$key=.*","$key=$value"} > ".\$uuid.tmp"
Remove-Item -Path .\config.ps1
Move-Item -Path ".\$uuid.tmp" -Destination ".\config.ps1"