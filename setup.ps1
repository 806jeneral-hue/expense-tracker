Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Expense Tracker - Setup Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $ProjectDir

# Step 1: Restore Flutter project (android + ios folders)
Write-Host ""
Write-Host "[1/4] Restoring Flutter project structure (android/ios)..." -ForegroundColor Yellow
flutter create --platforms android,ios . | Out-Null
Write-Host "     Done!" -ForegroundColor Green

# Step 2: Copy the new icon
Write-Host ""
Write-Host "[2/4] Replacing app icon..." -ForegroundColor Yellow
$IconSrc = "C:\Users\Mahmoud\.gemini\antigravity\brain\6824728c-c6ab-4e57-9df0-c2781d7ab083\expense_tracker_icon_1776985052349.png"
$IconDst = Join-Path $ProjectDir "assets\icon\app_icon.png"

if (Test-Path $IconSrc) {
    Copy-Item -Path $IconSrc -Destination $IconDst -Force
    Write-Host "     Icon replaced successfully!" -ForegroundColor Green
} else {
    Write-Host "     Icon source not found. Skipping..." -ForegroundColor Red
}

# Step 3: Get dependencies
Write-Host ""
Write-Host "[3/4] Running flutter pub get..." -ForegroundColor Yellow
flutter pub get
Write-Host "     Done!" -ForegroundColor Green

# Step 4: Generate launcher icons
Write-Host ""
Write-Host "[4/4] Generating launcher icons for Android..." -ForegroundColor Yellow
dart run flutter_launcher_icons
Write-Host "     Done!" -ForegroundColor Green

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " All done! You can now build your APK." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
