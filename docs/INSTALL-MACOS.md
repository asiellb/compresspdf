# macOS Installation Guide

This guide provides specific instructions for installing `compresspdf` on macOS.

## macOS Compatibility

The installer is fully compatible with:
- **macOS 10.15+** (Catalina and later)
- **Apple Silicon (M1/M2)** and **Intel processors**
- **System Integrity Protection (SIP)** enabled systems
- **Bash 3.x** (default) and **Bash 4.x+** (Homebrew)

## Automatic Detection

The installer automatically detects:
- ✅ Operating system version
- ✅ Processor architecture (Intel/Apple Silicon)
- ✅ Homebrew installation and prefix
- ✅ System Integrity Protection (SIP) status
- ✅ Available package managers
- ✅ Bash version and compatibility

## Quick Installation

```bash
# Download and run installer
curl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh | bash

# Or download first, then run
curl -O https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh
bash install.sh
```

## Prerequisites

### Required
- **Ghostscript** - PDF processing engine
- **Basic command line tools** (file, curl)

### Recommended
- **Homebrew** - Package manager for macOS
- **Xcode Command Line Tools** - Development utilities

## Installation Methods

### Method 1: Homebrew (Recommended)

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Ghostscript
brew install ghostscript

# Install compresspdf
curl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh | bash
```

### Method 2: Manual Installation

```bash
# Download and install Ghostscript manually
# Visit: https://www.ghostscript.com/download/gsdnld.html

# Install compresspdf
curl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh | bash
```

## macOS-Specific Features

### Smart Path Detection
- **Homebrew paths**: Automatically uses `/usr/local` or `/opt/homebrew`
- **Apple Silicon**: Detects `/opt/homebrew` on M1/M2 Macs
- **Intel**: Uses `/usr/local` prefix

### SIP Compatibility
- **SIP Enabled**: Automatically uses user installation (`~/.local/bin`)
- **SIP Disabled**: Offers system-wide installation (`/usr/local/bin`)
- **Permission Detection**: Handles `sudo` requirements intelligently

### Shell Completion
- **Bash**: Works with both macOS default and Homebrew Bash
- **Zsh**: Full compatibility with macOS default Zsh
- **Fish**: Supports Homebrew Fish installation

## Installation Locations

### System Installation (with sudo)
```
Binary:         /usr/local/bin/compresspdf
Manual:         /usr/local/share/man/man1/compresspdf.1
Bash completion: /usr/local/etc/bash_completion.d/compresspdf
Zsh completion:  /usr/local/share/zsh/site-functions/_compresspdf
```

### User Installation (recommended for SIP)
```
Binary:         ~/.local/bin/compresspdf
Manual:         ~/.local/share/man/man1/compresspdf.1
Bash completion: ~/.local/share/bash-completion/completions/compresspdf
Zsh completion:  ~/.local/share/zsh/site-functions/_compresspdf
Fish completion: ~/.config/fish/completions/compresspdf.fish
```

### Configuration and Data
```
Config:         ~/.config/compresspdf/config
Logs:           ~/.local/share/compresspdf/logs/compresspdf.log
```

## Troubleshooting

### Common Issues

**"gs: command not found"**
```bash
# Install Ghostscript via Homebrew
brew install ghostscript

# Or download from official site
open https://www.ghostscript.com/download/gsdnld.html
```

**"Permission denied" during installation**
```bash
# Force user installation
curl -fsSL https://install-script-url | bash -s -- --user

# Or install to user directory manually
mkdir -p ~/.local/bin
# ... manual installation steps
```

**Bash completion not working**
```bash
# For Bash (add to ~/.bash_profile)
source ~/.local/share/bash-completion/completions/compresspdf

# For Zsh (add to ~/.zshrc)
fpath=(~/.local/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit
```

**Old Bash version warnings**
```bash
# Install modern Bash via Homebrew
brew install bash
echo "/usr/local/bin/bash" | sudo tee -a /etc/shells
chsh -s /usr/local/bin/bash
```

### Verification Commands

```bash
# Check installation
compresspdf --version
compresspdf --help

# Test dependencies
scripts/install.sh check-deps

# Test with sample PDF
compresspdf --dry-run sample.pdf
```

## Uninstallation

```bash
# Complete removal
bash install.sh uninstall

# Manual cleanup if needed
rm -f ~/.local/bin/compresspdf
rm -f ~/.local/share/bash-completion/completions/compresspdf
rm -f ~/.local/share/zsh/site-functions/_compresspdf
rm -f ~/.config/fish/completions/compresspdf.fish
rm -rf ~/.config/compresspdf
rm -rf ~/.local/share/compresspdf
```

## Security Considerations

- ✅ Script validates all downloads
- ✅ Respects SIP and macOS security features
- ✅ Uses user directories when system installation blocked
- ✅ No modification of system-protected areas
- ✅ Clean uninstall removes all components

## Support

For macOS-specific issues:
1. Run diagnostic: `scripts/install.sh check-deps`
2. Check system compatibility with test script
3. Verify Homebrew setup: `brew doctor`
4. Report issues with system info: `sw_vers && uname -m`