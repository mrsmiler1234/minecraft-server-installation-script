# minecraft-server-installation-script
A bash script to automatically set up and configure a PaperMC server with the latest build version, configure RAM allocation, and support for installing custom maps from direct links (zip/7z). Simplifies installation and setup process for Minecraft server administrators.

## Dependencies

Before running the script, ensure that your system meets the following requirements:

- **Operating System:** Ubuntu or Debian (or derivatives)
- **Required packages:** `jq`, `curl`, `openjdk-17-jre-headless`, `p7zip-full`  
  These will be installed automatically by the script.
- **Minimum RAM:** At least **2 GB** of RAM (recommended to allocate more depending on the server size).
- **sudo privileges:** You need to have `sudo` access to install dependencies and set up the server.

## First install

Use the following steps to install the PaperMC server:

```shell
wget "https://raw.githubusercontent.com/latuk993/minecraft-server-installation-script/refs/heads/main/install.sh"
chmod +x install.sh
./install.sh MINECRAFT-VERSION
```

Example:

```
wget "https://raw.githubusercontent.com/latuk993/minecraft-server-installation-script/refs/heads/main/install.sh"
chmod +x install.sh
./install.sh 1.16.5
```

### Adding a map
You can also add a map directly during installation. After installing the kernel, you will be prompted to provide a direct link to the map (in .zip or .7z format):
