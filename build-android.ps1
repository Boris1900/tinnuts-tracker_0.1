# Build-Skript: Web-Dateien nach www/ kopieren + Capacitor sync
# Aufruf: .\build-android.ps1
# WICHTIG: Erst alle Änderungen und Versionsnummern aktualisieren, DANN dieses Skript!

$src = $PSScriptRoot
$www = "$src\www"

Write-Host "Kopiere Web-Dateien nach www/..." -ForegroundColor Cyan

# TinnitusTracker_Seedorf.html wird als index.html eingebunden (Capacitor erwartet index.html)
Copy-Item "$src\TinnitusTracker_Seedorf.html" "$www\index.html" -Force
Copy-Item "$src\sw.js"         "$www\sw.js"         -Force
Copy-Item "$src\manifest.json" "$www\manifest.json" -Force
Copy-Item "$src\icon-192.png"  "$www\icon-192.png"  -Force
Copy-Item "$src\icon-512.png"  "$www\icon-512.png"  -Force

Write-Host "Starte Capacitor Sync..." -ForegroundColor Cyan
npx cap sync android

Write-Host ""
Write-Host "Fertig! Jetzt in Android Studio:" -ForegroundColor Green
Write-Host "  Shift+Shift -> 'Generate APKs' -> warten -> APK umbenennen" -ForegroundColor Green
