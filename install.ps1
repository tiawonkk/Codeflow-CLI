Write-Host "Menginstal CodeFlow PowerShell Profile..." -ForegroundColor Cyan

# Pastikan folder profile ada
$profileDir = Split-Path -Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Salin isi konfigurasi ke $PROFILE
Copy-Item -Path ".\Microsoft.PowerShell_profile.ps1" -Destination $PROFILE -Force

# Aktifkan ExecutionPolicy
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force

Write-Host "Setup selesai! Muat ulang profil dengan mengetik: . `$PROFILE" -ForegroundColor Green