# Cursor IDE Debian Package Builder

A script to automatically download the latest Cursor IDE AppImage and convert it to a Debian package (.deb) for installation on Debian-based Linux distributions. A GitHub workflow will automatically upload the latest version of the package to the [releases page](https://github.com/jackinthebox52/cursor-deb/releases). (Every few days)

## Requirements

- Dpkg capable Linux environment
- Root
- Required packages: `curl`, `jq`, `dpkg-deb`


### Building the Latest Version

To build the latest version of Cursor IDE:

```bash
sudo ./auto-convert.sh
```

## Installing ()

After building, or downloading from releases, install the generated package:

```bash
sudo dpkg -i cursor-ide_*_amd64.deb
```

If there are dependency issues:

```bash
sudo apt-get install -f
```

## Uninstalling

To remove the package:

```bash
sudo apt-get remove cursor-ide
```

To completely remove the package and all configuration files:

```bash
sudo apt-get purge cursor-ide
```

## License

This project (Not Cursor) is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This is an unofficial package. Cursor IDE is developed by Anysphere, Inc. This repository is not affiliated with or endorsed by Anysphere.
