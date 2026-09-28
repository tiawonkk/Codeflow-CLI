# ========================================================
# 1. DEFINISI FUNGSI NAVIGASI PROYEK (proj / p)
# ========================================================
function proj {
    param([string]$folder)

    $basePath = "D:\Project"
    if (-not (Test-Path $basePath)) {
        Write-Host "Folder $basePath tidak ditemukan!" -ForegroundColor Red
        return
    }

    if ($folder) {
        switch ($folder.ToLower()) {
            "c"      { Set-Location "$basePath\C"; return }
            "cpp"    { Set-Location "$basePath\C++"; return }
            "c++"    { Set-Location "$basePath\C++"; return }
            "java"   { Set-Location "$basePath\Java"; return }
            "py"     { Set-Location "$basePath\Python"; return }
            "python" { Set-Location "$basePath\Python"; return }
        }
    }

    Write-Host "`n=== PILIH FOLDER PROYEK (D:\Project) ===" -ForegroundColor Cyan
    Write-Host "[1] C"
    Write-Host "[2] C++"
    Write-Host "[3] Java"
    Write-Host "[4] Python"
    Write-Host "[0] Buka Root D:\Project"
    Write-Host "[q] Batal (Tetap di sini)"
    Write-Host "========================================" -ForegroundColor Cyan

    $pilihan = Read-Host "Pilih nomor (0-4 / q)"
    switch ($pilihan) {
        "1" { Set-Location "$basePath\C" }
        "2" { Set-Location "$basePath\C++" }
        "3" { Set-Location "$basePath\Java" }
        "4" { Set-Location "$basePath\Python" }
        "0" { Set-Location "$basePath" }
        "q" { Write-Host "Dibatalkan." -ForegroundColor Yellow }
        Default { Write-Host "Pilihan tidak valid." -ForegroundColor Red }
    }
}

Set-Alias -Name p -Value proj

# ========================================================
# 2. DETEKSI LINGKUNGAN & KONDISI STARTUP
# ========================================================
$FLAG_PROJ = "$env:TEMP\terminal_proj_exit_flag.txt"

# Abaikan pengecekan jika sesi terminal ini dibuka di dalam VS Code
if ($env:TERM_PROGRAM -ne "vscode") {
    # Hanya arahkan ke menu proj jika sebelumnya ada trigger 'code exit' dan terminal baru dibuka
    if (Test-Path $FLAG_PROJ) {
        Remove-Item $FLAG_PROJ -Force -ErrorAction SilentlyContinue
        Set-Location "D:\Project"
        proj
    }
}

# ========================================================
# 3. GENERATOR TEMPLATE KODE
# ========================================================
function New-CodeTemplate {
    param([string]$filepath)
    $ext = [System.IO.Path]::GetExtension($filepath)
    $basename = [System.IO.Path]::GetFileNameWithoutExtension($filepath)

    if ((Test-Path $filepath) -and (Get-Item $filepath).Length -gt 0) {
        return
    }

    switch ($ext) {
        ".c" {
            @"
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
"@ | Out-File -FilePath $filepath -Encoding utf8
        }
        ".cpp" {
            @"
#include <iostream>

using namespace std;

int main() {
    cout << "Hello, World!" << endl;
    return 0;
}
"@ | Out-File -FilePath $filepath -Encoding utf8
        }
        ".java" {
            @"
public class $basename {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
"@ | Out-File -FilePath $filepath -Encoding utf8
        }
        ".py" {
            @"
def main():
    print("Hello, World!")

if __name__ == "__main__":
    main()
"@ | Out-File -FilePath $filepath -Encoding utf8
        }
        Default {
            New-Item -ItemType File -Path $filepath -Force | Out-Null
        }
    }
}

# ========================================================
# 4. COMMAND 'code' & 'code exit'
# ========================================================
function code {
    param(
        [Parameter(Position=0)]
        [string]$cmd,
        [Parameter(Position=1)]
        [string]$target
    )

    $currentDir = (Get-Location).Path

    # Logika code exit
    if ($cmd -eq "exit") {
        # Siapkan flag jika terminal ditutup
        New-Item -ItemType File -Path $FLAG_PROJ -Force | Out-Null

        # Tutup VS Code
        Stop-Process -Name "Code" -ErrorAction SilentlyContinue

        # Hapus flag langsung jika terminal saat ini tetap terbuka
        # Terminal saat ini tetap berada di folder proyek yang sedang dikerjakan
        Remove-Item $FLAG_PROJ -Force -ErrorAction SilentlyContinue
        Write-Host "VS Code ditutup. Posisi direktori tetap di $currentDir" -ForegroundColor Yellow
        return
    }

    if ($cmd -eq "--help" -or $cmd -eq "-h") {
        Write-Host "==========================================================" -ForegroundColor Cyan
        Write-Host "               PANDUAN COMMAND CODE & RUNNER              " -ForegroundColor Cyan
        Write-Host "==========================================================" -ForegroundColor Cyan
        Write-Host "1. Navigasi Proyek:"
        Write-Host "   proj / p                   -> Menu pilihan folder D:\Project"
        Write-Host "   p c / p java / p cpp / p py-> Langsung lompat ke folder spesifik"
        Write-Host ""
        Write-Host "2. Buka & Tutup VS Code:"
        Write-Host "   code .                     -> Buka folder aktif di VS Code"
        Write-Host "   code <nama_file>           -> Buka file spesifik"
        Write-Host "   code exit                  -> Tutup VS Code (posisi terminal tetap)"
        Write-Host ""
        Write-Host "3. Generate Template & Buka di VS Code:"
        Write-Host "   code make c                -> Buat main.c lalu buka folder & file"
        Write-Host "   code make cpp / c++        -> Buat main.cpp lalu buka folder & file"
        Write-Host "   code make java             -> Buat Main.java lalu buka folder & file"
        Write-Host "   code make py / python      -> Buat main.py lalu buka folder & file"
        Write-Host "   code make <nama_file.ext>  -> Buat file custom lalu buka folder & file"
        Write-Host ""
        Write-Host "4. Compile & Run Program:"
        Write-Host "   run code                   -> Deteksi otomatis & jalankan file di folder"
        Write-Host "   run code <nama_file.ext>   -> Compile & jalankan file spesifik"
        Write-Host "==========================================================" -ForegroundColor Cyan
        return
    }

    if ($cmd -eq "make") {
        if (-not $target) {
            Write-Host "Format salah! Gunakan: code make <c|cpp|java|py|nama_file.ext>" -ForegroundColor Red
            return
        }

        switch ($target) {
            "c" { $target = "main.c" }
            "cpp" { $target = "main.cpp" }
            "c++" { $target = "main.cpp" }
            "java" { $target = "Main.java" }
            "py" { $target = "main.py" }
            "python" { $target = "main.py" }
        }

        New-CodeTemplate -filepath $target
        code.cmd --disable-workspace-trust -r $currentDir $target
        return
    }

    if ($cmd -eq "." -or (-not $cmd -and -not $target)) {
        code.cmd --disable-workspace-trust -r $currentDir
        return
    }

    code.cmd --disable-workspace-trust $args
}

# ========================================================
# 5. COMMAND RUNNER 'run code'
# ========================================================
function run {
    param(
        [Parameter(Position=0)]
        [string]$action,
        [Parameter(Position=1)]
        [string]$file
    )

    if ($action -ne "code") {
        Write-Host "Gunakan: run code atau run code <nama_file>" -ForegroundColor Red
        return
    }

    if (-not $file) {
        $candidates = @("main.c", "main.cpp", "Main.java", "main.java", "main.py")
        foreach ($c in $candidates) {
            if (Test-Path $c) { $file = $c; break }
        }
        if (-not $file) {
            $found = Get-ChildItem -File | Where-Object { $_.Extension -in @(".c", ".cpp", ".java", ".py") } | Select-Object -First 1
            if ($found) { $file = $found.Name }
        }
    }

    if (-not $file -or -not (Test-Path $file)) {
        Write-Host "File kode (.c, .cpp, .java, .py) tidak ditemukan di folder ini." -ForegroundColor Red
        return
    }

    $ext = [System.IO.Path]::GetExtension($file)
    $name = [System.IO.Path]::GetFileNameWithoutExtension($file)

    Write-Host "--- Menjalankan $file ---" -ForegroundColor Green
    switch ($ext) {
        ".c" {
            gcc $file -o "$name.exe"
            if ($LASTEXITCODE -eq 0) { & ".\$name.exe" }
        }
        ".cpp" {
            g++ $file -o "$name.exe"
            if ($LASTEXITCODE -eq 0) { & ".\$name.exe" }
        }
        ".java" {
            java $file
        }
        ".py" {
            python $file
        }
    }
}