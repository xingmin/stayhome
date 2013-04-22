function Get-InternetTime { 
	return (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
	$TcpClient = New-Object System.Net.Sockets.TcpClient 
	[byte[]]$buffer = ,0 * 64 
	$TcpClient.Connect('time.nist.gov', 13) 
	$TcpStream = $TcpClient.GetStream() 
	$length = $TcpStream.Read($buffer, 0, $buffer.Length); 
	[void]$TcpClient.Close() 
	$raw = [Text.Encoding]::ASCII.GetString($buffer) 
	Write-Debug $raw 
	$d = [DateTime]::ParseExact($raw.SubString(7,17), 'yy-MM-dd HH:mm:ss', $null).toLocalTime().ToString("yyyy-MM-dd HH:mm:ss")
	return $d;
}