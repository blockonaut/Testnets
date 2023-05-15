There are two bashscript variants available. 
The first one (AutoInstall.sh) is a oneclick script.
The second one (InstallScript.sh) is a guided installation script.

# One-click automated installation of celestia-appd (fullnode), celestia bridge and dependencies:

In the script itself the necessary variables are defined at the beginning. 
These can be adapted as desired. All variables are explained by comment.
In any case at least "node_name=" should be adjusted.

The only interaction necessary is pressing Enter after saving the mnemonic phrase.

## Quick Start AutoInstall:

```wget https://raw.githubusercontent.com/blockonaut/Testnets/main/Celestia/Bonus_Tasks/Tooling/AutoInstall.sh```

for downloading the AutoInstall.sh Bashscript

```nano AutoInstall.sh```

for updating the variables

```chmod +x AutoInstall.sh``` 

for making it executable and then

```sudo ./AutoInstall.sh```

for starting the automated Installer

Video:
[![asciicast](https://asciinema.org/a/ZfSqs5ocWoGFOTpNJFwAXb6qh.svg)](https://asciinema.org/a/ZfSqs5ocWoGFOTpNJFwAXb6qh)

# Bashscript for guided installation of celestia-appd (fullnode), celestia bridge node and dependecies

Guided installation with all necessary dependencies.
The script is intentionally simple and does not need any other packages itself.

## Quick Start guided InstallScript:

```wget https://raw.githubusercontent.com/blockonaut/Testnets/main/Celestia/Bonus_Tasks/Tooling/InstallScript.sh```

for downloading the InstallScript.sh Bashscript

```chmod +x InstallScript.sh``` 

for making it executable and then

```sudo ./InstallScript.sh```

for starting the Installer
