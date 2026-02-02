# AellyX Bot Client Setup Script
# Run this on your test Windows machines to set them up as bots
# Usage: .\setup_bot.ps1 -ServerUrl "http://your-vps-ip:5261/" -Password "your-password"

param(
    [Parameter(Mandatory=$true)]
    [string]$ServerUrl,
    
    [Parameter(Mandatory=$true)]
    [string]$Password
)

$InstallPath = "$env:LOCALAPPDATA\AellyX"
$RepoUrl = "https://github.com/k4ran909/AellyX/archive/refs/heads/main.zip"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   AellyX Bot Client Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check for Python
Write-Host "[1/5] Checking for Python..." -ForegroundColor Yellow
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Host "Python is not installed. Please install Python 3.8+ first." -ForegroundColor Red
    Write-Host "Download from: https://www.python.org/downloads/" -ForegroundColor Red
    exit 1
}
Write-Host "      Python found: $($python.Source)" -ForegroundColor Green

# Step 2: Create installation directory
Write-Host "[2/5] Creating installation directory..." -ForegroundColor Yellow
if (Test-Path $InstallPath) {
    Remove-Item -Recurse -Force $InstallPath
}
New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
Write-Host "      Created: $InstallPath" -ForegroundColor Green

# Step 3: Download AellyX
Write-Host "[3/5] Downloading AellyX..." -ForegroundColor Yellow
$zipPath = "$env:TEMP\aellyx.zip"
Invoke-WebRequest -Uri $RepoUrl -OutFile $zipPath
Expand-Archive -Path $zipPath -DestinationPath $InstallPath -Force
Move-Item "$InstallPath\AellyX-main\*" $InstallPath -Force
Remove-Item "$InstallPath\AellyX-main" -Force
Remove-Item $zipPath -Force
Write-Host "      Downloaded and extracted" -ForegroundColor Green

# Step 4: Create virtual environment and install dependencies
Write-Host "[4/5] Setting up Python environment..." -ForegroundColor Yellow
Push-Location $InstallPath
python -m venv .venv
& "$InstallPath\.venv\Scripts\pip.exe" install -r requirements.txt -q
Pop-Location
Write-Host "      Dependencies installed" -ForegroundColor Green

# Step 5: Create the bot launcher script
Write-Host "[5/5] Creating bot launcher..." -ForegroundColor Yellow

$botScript = @"
# AellyX Bot Client - Auto-connects to C&C server
import sys
sys.path.insert(1, "./AellyX/")

from importlib import import_module
import requests
from time import sleep

SERVER_URL = "$ServerUrl"
PASSWORD = "$Password"

def connect_as_bot():
    from CLIF_Framework.framework import console
    
    # Create console instance
    var = console()
    var.user_argv = ["main.py"]
    
    # Configure as bot (not host)
    var.server = [True, False, SERVER_URL, PASSWORD, 1]
    
    # Reset server state
    try:
        requests.post(SERVER_URL + "reset", data={"password": PASSWORD}, timeout=5)
        print(f"[+] Connected to C&C server: {SERVER_URL}")
    except Exception as e:
        print(f"[-] Failed to connect: {e}")
        return
    
    # Run the main module
    main = import_module("AellyX.main")
    main.run()

if __name__ == "__main__":
    print("=" * 50)
    print("AellyX Bot Client")
    print(f"Connecting to: {SERVER_URL}")
    print("=" * 50)
    connect_as_bot()
"@

$botScript | Out-File -FilePath "$InstallPath\bot_client.py" -Encoding utf8
Write-Host "      Bot launcher created" -ForegroundColor Green

# Create a simple batch file to run the bot
$batchContent = @"
@echo off
cd /d "$InstallPath"
call .venv\Scripts\activate.bat
python bot_client.py
pause
"@
$batchContent | Out-File -FilePath "$InstallPath\run_bot.bat" -Encoding ascii

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Installation Path: $InstallPath" -ForegroundColor White
Write-Host "Server URL: $ServerUrl" -ForegroundColor White
Write-Host ""
Write-Host "To run the bot manually:" -ForegroundColor Yellow
Write-Host "   $InstallPath\run_bot.bat" -ForegroundColor Cyan
Write-Host ""
Write-Host "To add to startup (Task Scheduler):" -ForegroundColor Yellow
Write-Host "   1. Open Task Scheduler (taskschd.msc)" -ForegroundColor White
Write-Host "   2. Create Basic Task > Name: 'AellyX Bot'" -ForegroundColor White
Write-Host "   3. Trigger: 'When I log on'" -ForegroundColor White
Write-Host "   4. Action: 'Start a program'" -ForegroundColor White
Write-Host "   5. Program: $InstallPath\run_bot.bat" -ForegroundColor White
Write-Host ""
