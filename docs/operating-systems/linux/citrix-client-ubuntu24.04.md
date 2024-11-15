# Citrix workspace in Ubuntu 24.04

## Install dependencies

As root

```shell
cat << EOF >> /etc/apt/sources.list.d/jammy.list
deb <http://gb.archive.ubuntu.com/ubuntu> jammy main
apt update
apt install libwebkit2gtk-4.0-dev
rm -f /etc/apt/sources.list.d/jammy.list
apt update
```

## Install

As user, download the tarball from here

- Citrix Workspace app
<https://www.citrix.com/downloads/workspace-app/linux/>

Uncompress and exec the installer

```shell
./setupwfc
```

## Links

- Install, Uninstall, and Update
<https://docs.citrix.com/en-us/citrix-workspace-app-for-linux/install.html>
