# 🚀 Cursor AppImage to DEB Converter

This bash script automatically converts Cursor IDE AppImage to .deb package for Debian/Ubuntu distributions.

## ✨ Features

- **Robust error handling** with comprehensive logging system
- **Optimized performance** with rsync
- **Automatic validation** of package integrity
- **Multi-architecture support** (amd64/arm64)

### 📋 **Available Options**
- Verbose (`-v`) and quiet (`-q`) modes
- Customizable output directory (`-o`)
- Specific version (`--version`)
- Configuration file (`--config`)

## 🛠️ Installation and Usage

### Prerequisites
```bash
# Install dependencies
sudo apt update
sudo apt install curl jq dpkg-dev rsync

# Make script executable
chmod +x auto-convert.sh
```

### Basic Usage
```bash
# Standard conversion
./auto-convert.sh

# Verbose mode with temporary files retention
./auto-convert.sh -v -k

# Specify output directory
./auto-convert.sh -o /tmp/packages

# Download specific version
./auto-convert.sh --version 0.42.0
```

## 📖 Available Options

| Option | Description |
|--------|-------------|
| `-k, --keep-temp` | Keep temporary files |
| `-v, --verbose` | Verbose mode with details |
| `-q, --quiet` | Quiet mode |
| `-o, --output DIR` | Output directory |
| `-c, --config FILE` | Configuration file |
| `--version VERSION` | Specific version to download |
| `--no-rsync` | Use `cp` instead of `rsync` |
| `-h, --help` | Display help |

## 🎯 Advanced Usage Example

```bash
# Complete configuration
./auto-convert.sh \
    --verbose \
    --keep-temp \
    --output /home/user/packages \
    --version 0.42.0
```

## 📁 Generated Package Structure

The created .deb package includes:
- **Binary**: `/usr/bin/cursor`
- **Application**: `/opt/cursor/`
- **Icon**: `/usr/share/icons/hicolor/512x512/apps/cursor.png`
- **Menu**: `/usr/share/applications/cursor.desktop`
- **Dependencies**: All necessary libraries

## 🔍 Log Files

The script automatically generates a detailed log file:
```
/tmp/cursor-convert-[timestamp].log
```

## 🛡️ Security and Validation

- **Package integrity verification**
- **System dependencies validation**
- **Configured download timeouts**
- **Automatic cleanup on errors**

## 🎨 Configuration File

Create a configuration file to customize settings:

```bash
# cursor-config.conf
USE_RSYNC=true
VERBOSE=true
```

Use with:
```bash
./auto-convert.sh --config cursor-config.conf
```

## 📊 Comparison with Previous Version

| Feature | Previous Version | New Version |
|---------|------------------|-------------|
| Error handling | Basic | Robust with logging |
| Performance | Standard | Optimized with rsync |
| Validation | None | Complete validation |
| Options | 2 options | 8+ options |
| Architecture | x86_64 only | Multi-architecture |
| Logging | Basic messages | Complete system |
| Dependencies | Minimal | Complete |

## 🚀 Performance Optimizations

1. **Rsync**: Faster copying with progress indicator
2. **Timeouts**: Avoid network hangs
3. **Validation**: Fast integrity verification

## 🔧 Troubleshooting

### Common Issues

**Missing dependencies**:
```bash
sudo apt install curl jq dpkg-dev rsync
```

**Network issues**:
```bash
./auto-convert.sh --verbose  # To see details
```

## 📝 Logging

The script generates detailed logs with:
- Timestamp for each operation
- Log levels (INFO, WARN, ERROR, DEBUG)
- Performance information
- Error details

## 🎉 Package Installation

Once the package is created:
```bash
# Install package
sudo dpkg -i cursor-ide_*_amd64.deb

# Resolve dependencies if needed
sudo apt-get install -f

# Launch Cursor
cursor
```

## 🤝 Contributing

This script is optimized for performance and robustness. Contributions are welcome!

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## Disclaimer

This is an unofficial package. Cursor IDE is developed by Anysphere, Inc. This repository is not affiliated with or endorsed by Anysphere.
