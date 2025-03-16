# minecraft-server-installation-script
A bash script to automatically set up and configure a PaperMC server with the latest build version, configure RAM allocation, and support for installing custom maps from direct links (zip/7z). Simplifies installation and setup process for Minecraft server

## First install

Use:

```shell
wget "https://raw.githubusercontent.com/latuk993/minecraft-server-installation-script/refs/heads/main/install.sh"
chmod +x install.sh
./install.sh MINECRAFT-VERSION
```

Example:

```shell
wget "https://raw.githubusercontent.com/latuk993/minecraft-server-installation-script/refs/heads/main/install.sh"
chmod +x install.sh
./install.sh 1.16.5
```

### Addind a map

You can also add a map directly during installation. After installing the kernel, you will be prompted to send a direct link to the map
