$fileName = "$env:USERPROFILE\AppData\Local\Programs\Microsoft-Powershell\test.txt"
$textContent = "Dies ist eine automatisch generierte Textdatei."
$message = @{
    "content" = "alles funktoniert"
}
$webhookUrl = "https://discord.com/api/webhooks/1244307598715392142/-vO1h_4pVUviMNNcT5qKSXEsHwphKIwEfzNjKYeGNq5tCGmBliYacDuW4kYGv5aggxW_"
New-Item -Path $fileName -ItemType File -Force | Out-Null
Set-Content -Path $fileName -Value $textContent

Invoke-RestMethod -Uri $webhookUrl -Method Post -Body ($message | ConvertTo-Json) -ContentType "application/json"
