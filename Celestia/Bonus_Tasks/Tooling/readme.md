There are two bashscript variants available. The first one (AutoInstall.sh) is a oneclick solution. 

## One-click automated installation of celestia-appd (fullnode), celestia bridge and dependencies:

In the script itself the necessary variables are defined at the beginning. 
These can be adapted as desired. All variables are explained by comment.
In any case at least "node_name=" should be adjusted.

The only interaction necessary is pressing Enter after saving the mnemonic phrase.

Quick howto:
```chmod +x AutoInstall.sh``` 
for making it executable and then

```sudo ./AutoInstall.sh```
for starting the automated Installer

## Bashscript for guided installation of celestia-appd (fullnode), celestia bridge node and dependecies

Guided installation with all necessary dependencies.
The script is intentionally simple and does not need any other packages itself.

```chmod +x InstallScript.sh``` 
for making it executable and then

```sudo ./InstallScript.sh```
for starting the Installer
