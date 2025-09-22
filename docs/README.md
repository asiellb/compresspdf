# CompressPDF 2.0

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell](https://img.shields.io/badge/Shell-bash-blue.svg)](https://www.gnu.org/software/bash/)
[![Version](https://img.shields.io/badge/Version-2.0.0-green.svg)](#)

A professional-grade command-line tool for PDF compression, optimization, and manipulation using Ghostscript. Enhanced with modern bash practices, comprehensive error handling, and intelligent autocompletion.

## ✨ Features

- **Professional PDF Compression**: Multiple quality presets from screen-optimized to prepress-ready
- **Intelligent Page Extraction**: Extract specific page ranges with validation
- **Advanced Color Management**: Full color or grayscale conversion with ICC profile support
- **Metadata Control**: Clean or preserve document metadata and bookmarks
- **Smart Autocompletion**: Context-aware tab completion for files and options (bash/zsh/fish)
- **Configuration Management**: Persistent user preferences and settings
- **Comprehensive Logging**: Detailed operation logs with multiple verbosity levels
- **Progress Indicators**: Real-time feedback with visual progress indicators
- **Error Recovery**: Robust error handling with helpful diagnostic messages
- **Cross-Platform**: Works on macOS, Linux, and Unix-like systems

## 🚀 Quick Start

### Installation

```bash
# Simple one-line installation
curl -L https://git.io/fj98I | bash

# Or download and run the enhanced installer
curl -L https://raw.githubusercontent.com/asiellb/compresspdf/master/install-enhanced.sh | bash
```

### Basic Usage

```bash
# Compress a PDF with default settings
compresspdf document.pdf

# High-quality compression for printing
compresspdf -s printer document.pdf

# Extract pages 10-20 in grayscale
compresspdf -i 10 -e 20 -g document.pdf

# Custom output with metadata cleaning
compresspdf -o compressed.pdf -c document.pdf
```

## 📖 Detailed Usage

### Command Syntax

```bash
compresspdf [OPTIONS] -f <input-file>
compresspdf [OPTIONS] <input-file>
```

### Options Reference

| Option | Long Form | Description | Example |
|--------|-----------|-------------|---------|
| `-f` | `--file` | Input PDF file to compress | `-f document.pdf` |
| `-o` | `--output` | Output filename (default: input_small.pdf) | `-o compressed.pdf` |
| `-s` | `--setting` | Compression quality preset | `-s printer` |
| `-l` | `--layout` | Page layout/paper size | `-l a4` |
| `-i` | `--initial` | First page for extraction | `-i 5` |
| `-e` | `--end` | Last page for extraction | `-e 15` |
| `-g` | `--grayscale` | Convert to grayscale | `-g` |
| `-c` | `--clean` | Remove metadata and bookmarks | `-c` |
| `-v` | `--verbose` | Enable verbose output | `-v` |
| `-q` | `--quiet` | Suppress non-error output | `-q` |
| | `--force` | Overwrite existing files | `--force` |
| | `--dry-run` | Preview command without execution | `--dry-run` |
| | `--config` | Use custom config file | `--config myconfig` |
| `-h` | `--help` | Show help information | `-h` |
| | `--version` | Display version information | `--version` |
| `-u` | `--update` | Update to latest version | `-u` |

### Compression Settings

| Setting | Resolution | Use Case | File Size |
|---------|------------|----------|-----------|
| `screen` | 72 DPI | Web viewing, email | Smallest |
| `ebook` | 150 DPI | E-readers, tablets | Small |
| `default` | Variable | General purpose | Medium |
| `printer` | 300 DPI | Desktop printing | Large |
| `prepress` | 300 DPI | Professional printing | Largest |

### Page Layouts

| Layout | Dimensions | Description |
|--------|------------|-------------|
| `letter` | 8.5" × 11" | US standard |
| `a4` | 210 × 297 mm | International standard |
| `legal` | 8.5" × 14" | US legal documents |

## 💡 Examples

### Basic Compression

```bash
# Simple compression with default settings
compresspdf document.pdf
# Output: document_small.pdf

# Compress for web use (smallest size)
compresspdf -s screen document.pdf

# High-quality compression for printing
compresspdf -s printer -o print-ready.pdf document.pdf
```

### Page Range Extraction

```bash
# Extract pages 1-10
compresspdf -i 1 -e 10 document.pdf

# Extract and compress pages 25-50 for printing
compresspdf -i 25 -e 50 -s printer document.pdf

# Extract single page (page 5)
compresspdf -i 5 -e 5 document.pdf
```

### Advanced Options

```bash
# Grayscale conversion with metadata cleaning
compresspdf -g -c document.pdf

# Verbose compression with custom output
compresspdf -v -o ~/Desktop/compressed.pdf document.pdf

# A4 layout for international documents
compresspdf -l a4 -s ebook document.pdf

# Dry run to preview the command
compresspdf --dry-run -v -s printer document.pdf
```

### Batch Processing

```bash
# Process multiple files (requires shell loop)
for file in *.pdf; do
    compresspdf -s screen "$file"
done

# Process with custom naming
for file in *.pdf; do
    compresspdf -o "compressed_${file}" "$file"
done
```

## ⚙️ Configuration

### Configuration File

CompressPDF supports persistent configuration through `~/.config/compresspdf/config`:

```bash
# Create default configuration
compresspdf --create-config

# Use custom configuration
compresspdf --config /path/to/custom/config document.pdf
```

Example configuration file:

```ini
# Default compression setting
default_setting=screen

# Default page layout
default_layout=letter

# Enable verbose output by default
verbose=false

# Enable quiet mode by default
quiet=false
```

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `COMPRESSPDF_CONFIG` | Path to configuration file | `~/.config/compresspdf/config` |
| `COMPRESSPDF_LOG_LEVEL` | Logging verbosity (DEBUG/INFO/WARNING/ERROR) | `INFO` |

## 🔧 Installation Details

### System Requirements

- **Operating System**: macOS, Linux, or Unix-like system
- **Shell**: bash 4.0+ (for full feature support)
- **Required Dependencies**:
  - Ghostscript (`gs`)
  - `file` command
  - `curl` or `wget`
- **Optional Dependencies**:
  - `du` (file size calculations)
  - `stat` (file information)

### Dependency Installation

#### macOS (Homebrew)
```bash
brew install ghostscript
```

#### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install ghostscript file curl
```

#### CentOS/RHEL/Fedora
```bash
# CentOS/RHEL
sudo yum install ghostscript file curl

# Fedora
sudo dnf install ghostscript file curl
```

#### Arch Linux
```bash
sudo pacman -S ghostscript file curl
```

### Manual Installation

1. **Download the script**:
   ```bash
   curl -L https://raw.githubusercontent.com/asiellb/compresspdf/master/compresspdf-enhanced -o compresspdf
   chmod +x compresspdf
   ```

2. **Install to system PATH**:
   ```bash
   sudo mv compresspdf /usr/local/bin/
   ```

3. **Install autocompletion** (optional):
   ```bash
   # Bash
   curl -L https://raw.githubusercontent.com/asiellb/compresspdf/master/compresspdf-completion.bash -o ~/.local/share/bash-completion/completions/compresspdf
   
   # Zsh
   curl -L https://raw.githubusercontent.com/asiellb/compresspdf/master/compresspdf-completion.bash -o ~/.local/share/zsh/site-functions/_compresspdf
   ```

## 🎯 Autocompletion

The enhanced version includes intelligent autocompletion that provides:

- **Option completion**: Tab-complete all available options
- **File completion**: Smart completion for PDF files in the current directory
- **Value completion**: Complete valid values for options like `--setting` and `--layout`
- **Context-aware**: Adapts suggestions based on current command context

### Enabling Autocompletion

Autocompletion is automatically installed with the enhanced installer. To enable manually:

```bash
# Bash - add to ~/.bashrc
source ~/.local/share/bash-completion/completions/compresspdf

# Zsh - add to ~/.zshrc
fpath=(~/.local/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit

# Fish - automatically loaded from ~/.config/fish/completions/
```

## 📊 Performance & Optimization

### Compression Ratios

Typical compression ratios by setting:

| Setting | Typical Reduction | Quality | Speed |
|---------|------------------|---------|-------|
| `screen` | 70-90% | Low | Fast |
| `ebook` | 50-70% | Medium | Medium |
| `default` | 40-60% | Good | Medium |
| `printer` | 20-40% | High | Slow |
| `prepress` | 10-30% | Highest | Slowest |

### Performance Tips

1. **Use appropriate settings**: Don't use `prepress` for web documents
2. **Page ranges**: Extract only needed pages to reduce processing time
3. **Grayscale conversion**: Can significantly reduce file size for text documents
4. **Metadata cleaning**: Removes unnecessary data for smaller files

## 🔍 Troubleshooting

### Common Issues

#### "gs: command not found"
```bash
# Install Ghostscript
# macOS:
brew install ghostscript

# Linux:
sudo apt-get install ghostscript  # Ubuntu/Debian
sudo yum install ghostscript      # CentOS/RHEL
```

#### "Permission denied"
```bash
# Make script executable
chmod +x /usr/local/bin/compresspdf

# Or install with proper permissions
sudo ./install-enhanced.sh
```

#### "Input file is not a valid PDF"
```bash
# Verify file type
file document.pdf

# Check file permissions
ls -la document.pdf
```

#### Large files taking too long
```bash
# Use faster settings for large files
compresspdf -s screen large-document.pdf

# Or extract specific pages first
compresspdf -i 1 -e 50 large-document.pdf
```

### Debug Mode

Enable verbose logging for troubleshooting:

```bash
# Verbose output
compresspdf -v document.pdf

# Dry run to see exact command
compresspdf --dry-run -v document.pdf

# Check logs
tail -f ~/.local/share/compresspdf/logs/compresspdf.log
```

### Getting Help

1. **Built-in help**: `compresspdf --help`
2. **Version info**: `compresspdf --version`
3. **Check dependencies**: Run the installer with `check-deps`
4. **Log files**: Check `~/.local/share/compresspdf/logs/`
5. **GitHub Issues**: [Report bugs](https://github.com/asiellb/compresspdf/issues)

## 🔄 Updates

### Automatic Updates

```bash
# Update to latest version
compresspdf --update

# Or use the installer
curl -L https://git.io/fj98I | bash
```

### Manual Updates

```bash
# Download latest installer
curl -L https://raw.githubusercontent.com/asiellb/compresspdf/master/install-enhanced.sh -o install.sh
chmod +x install.sh
./install.sh update
```

## 🗑️ Uninstallation

```bash
# Download and run uninstaller
curl -L https://raw.githubusercontent.com/asiellb/compresspdf/master/install-enhanced.sh | bash -s uninstall

# Or run local installer
./install-enhanced.sh uninstall
```

This will remove:
- Main script (`/usr/local/bin/compresspdf`)
- Completion scripts
- Configuration files (with confirmation)
- Log files (with confirmation)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

```bash
# Clone repository
git clone https://github.com/asiellb/compresspdf.git
cd compresspdf

# Make scripts executable
chmod +x compresspdf-enhanced install-enhanced.sh

# Test installation
./install-enhanced.sh check-deps
```

## 🎉 Acknowledgments

- Built on top of [Ghostscript](https://www.ghostscript.com/)
- Inspired by the original compresspdf script
- Enhanced with modern bash practices and professional features

## 📋 Changelog

### Version 2.0.0
- Complete rewrite with modern bash practices
- Added intelligent autocompletion (bash/zsh/fish)
- Implemented configuration file support
- Added comprehensive logging system
- Enhanced CLI with colors and progress indicators
- Improved error handling and validation
- Added dry-run mode and force overwrite options
- Professional installation system with dependency checking
- Comprehensive documentation and man page

### Version 1.x
- Original script with basic functionality
- Simple PDF compression using Ghostscript
- Basic command-line options

---

For more information and advanced usage examples, visit the [GitHub repository](https://github.com/asiellb/compresspdf).