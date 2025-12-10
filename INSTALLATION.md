# AellyX

<a style="color: white;" href="https://github.com/k4ran909/AellyX/blob/main/INSTALLATION.md#lazy-installer">Advanced</a> - <a style="color: white;" href="https://github.com/k4ran909/AellyX/blob/main/INSTALLATION.md#or-start-your-unix-terminal-and-type-in-following">Expert</a> - <a style="color: white;" href="https://github.com/k4ran909/AellyX/blob/main/INSTALLATION.md#other-operating-systems">Other operating systems</a> - <a style="color: white;" href="https://github.com/k4ran909/AellyX/blob/main/INSTALLATION.md#uninstall">Uninstall</a>

## Lazy installer
(Advanced)

To install AellyX enter the following command:

(You might need to install curl)

```curl -s https://raw.githubusercontent.com/k4ran909/AellyX/main/install.sh | sudo bash -s```

![render1604868703436](https://user-images.githubusercontent.com/36562445/98484164-d0ec5300-220d-11eb-8fe5-0c9d4d2103e6.gif)

## Or start your Unix terminal and type in following

(Expert)

```sudo pkg/pacman/apt-get/brew install git python3 nmap python3-setuptools bluez dsniff iputils-ping aircrack-ng```

```git clone https://github.com/k4ran909/AellyX/```

```cd AellyX```

```sudo bash install_to_bin.sh```

```sudo rst```

## Other Operating Systems

(Unix based systems like Linux and MacOS/OSX run AellyX nativly.)
(In case you want to use AellyX on Windows, you will just need to perform the steps listed below, but keep in mind that it will not run as stable and not every module will work.)

Just install python 3.8 and download this repository.

You will then need to install the requirements (requirements.txt) and execute main.py.

0. Install Python (3.8) (3.6 should work as well.) (On windows, make sure to enable add to PATH.)

1. Download Zip

2. Unzip

3. Open terminal in the AellyX folder. (On windows you should be able to just right click the folder while holding down the shift key, you can then click on open in Powershell (administrator).)

4. Install the requirements.

`pip install -r requirements.txt`

5. Execute AellyX.

`python main.py`

(You might need to add a 3 directly after python and pip.)

## Uninstall

Just execute the folowing:

```
sudo bash /usr/share/AellyX/uninstall.sh
```
