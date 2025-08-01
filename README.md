# Cursor IDE Debian Package Builder

A script to automatically download the latest Cursor IDE AppImage and convert it to a Debian package (.deb) for installation on Debian-based Linux distributions. A GitHub workflow will automatically upload the latest version of the package to the [releases page](https://github.com/lde-axelor/cursor-deb/releases). (Every days)

## Requirements

- Dpkg capable Linux environment
- Root
- Required packages: `curl`, `jq`, `dpkg-deb`


### Building the Latest Version

To build the latest version of Cursor IDE:

```bash
./auto-convert.sh
```

## Installing

After building, or downloading from releases, install the generated package:

```bash
sudo apt install ./cursor-ide_*_amd64.deb
```

## Updating

A fish function is provided to update the cursor IDE to the latest version.

Copy the cursor_update.fish file to your fish config directory.

```bash
cp cursor_update.fish ~/.config/fish/functions/cursor_update.fish
```

Then, you can update the cursor IDE to the latest version by running the following command:

```bash
cursor_update
```

## Uninstalling

To remove the package:

```bash
sudo apt remove cursor-ide
```

To completely remove the package and all configuration files:

```bash
sudo apt purge cursor-ide
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This is an unofficial package. Cursor IDE is developed by Anysphere, Inc. This repository is not affiliated with or endorsed by Anysphere.
