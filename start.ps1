$fileName = "$env:USERPROFILE\AppData\Local\Programs\Microsoft-Powershell\test.txt"
$textContent = "Dies ist eine automatisch generierte Textdatei."

New-Item -Path $fileName -ItemType File -Force | Out-Null
Set-Content -Path $fileName -Value $textContent
