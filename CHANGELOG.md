# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- Fixed BASH_SOURCE unbound variable error when install script is piped from curl
- Improved compatibility with different shell environments and execution contexts

## [2.0.0] - 2025-09-21

### Added

#### Core Features
- **Professional modular architecture** with clean separation of concerns
- **Comprehensive logging system** with DEBUG, INFO, WARNING, ERROR levels
- **Configuration file support** with automatic creation and loading
- **Advanced argument parsing** with full option validation
- **Dry-run mode** for safe command preview before execution
- **Progress indicators** and detailed status reporting
- **Update functionality** with automatic version checking
- **Comprehensive error handling** with specific exit codes

#### Compression Options
- **5 quality levels**: default, screen, ebook, printer, prepress
- **Page format support**: letter, a4, legal, prepress
- **Grayscale conversion** option with optimized color space handling
- **Metadata cleaning** to remove sensitive information
- **Page range extraction** for partial PDF processing
- **Custom output filename** specification
- **Force overwrite** option for existing files

#### Cross-Platform Compatibility
- **Full macOS support** including Bash 3.x compatibility
- **System Integrity Protection (SIP)** aware installation
- **Multi-platform dependency detection** (macOS, Linux, Unix)
- **Intelligent package manager detection** (Homebrew, apt, dnf, pacman, etc.)
- **OS-specific installation instructions** with automatic detection
- **Bash 3.x compatibility** removing declare -g and readarray dependencies

#### Shell Integration
- **Advanced autocompletion** for Bash, Zsh, and Fish shells
- **Context-aware file completion** for PDF files
- **Option completion** for all command-line arguments
- **Installation helpers** for system-wide and user completion setup

#### Installation System
- **Smart installation script** with OS detection
- **Multiple installation methods** (system-wide, user-only)
- **Automatic dependency checking** and installation guidance
- **Clean uninstallation** with complete component removal
- **Update mechanism** with rollback capability

#### Documentation
- **Comprehensive man page** (compresspdf.1)
- **Detailed README** with examples and usage patterns
- **macOS-specific installation guide** (INSTALL-MACOS.md)
- **Project structure documentation** (STRUCTURE.md)
- **Professional project organization** following industry standards

### Changed

#### Project Structure
- **Reorganized directory structure** following modern best practices:
  ```
  ├── src/              # Source code
  ├── scripts/          # Installation and utility scripts  
  ├── docs/             # Documentation
  ├── tests/            # Test framework (prepared)
  ├── examples/         # Example files and configurations
  ├── Makefile          # Build automation
  └── README.md         # Quick start guide
  ```

#### Script Architecture
- **Migrated from monolithic to modular design** with dedicated functions
- **Enhanced error handling** with proper exit codes and recovery
- **Improved dependency management** with fallback mechanisms
- **Standardized logging** throughout all components

#### Installation Process
- **Intelligent path detection** for different operating systems
- **SIP-aware installation** preferring user directories when needed
- **Homebrew integration** with automatic prefix detection
- **Enhanced completion installation** with shell-specific handling

### Fixed

#### macOS Compatibility
- **Bash 3.x compatibility issues** resolved
- **declare -g statements** replaced with standard variable declarations
- **readarray usage** replaced with portable alternatives
- **Array slicing** replaced with shift-based argument parsing
- **stat/du command differences** handled with OS-specific fallbacks

#### Cross-Platform Issues
- **File size calculation** now works across different stat implementations
- **Command execution** using eval for broader compatibility
- **Path handling** improved for various filesystem layouts
- **Package manager detection** enhanced for edge cases

#### Installation Robustness
- **Permission handling** improved for restricted environments
- **Cleanup procedures** enhanced for failed installations
- **Dependency verification** made more reliable
- **Error reporting** clarified with actionable suggestions

### Security

#### Safe Installation
- **No system file modifications** in protected areas
- **SIP compliance** with user-space installation fallback
- **Input validation** for all command-line arguments
- **Safe temporary file handling** with proper cleanup
- **Checksum verification** for downloaded components

#### Privacy
- **Optional metadata cleaning** removes sensitive PDF information
- **No data collection** or external reporting
- **Local-only configuration** storage

### Performance

#### Optimizations
- **Efficient ghostscript parameter optimization** for each quality level
- **Reduced temporary file usage** with streaming where possible
- **Faster dependency checking** with cached results
- **Optimized compression algorithms** for better size/quality ratios

### Dependencies

#### System Requirements
- **Ghostscript** (gs) - PDF processing engine
- **file** command - MIME type detection
- **curl** or **wget** - Download functionality
- **Basic shell utilities** (du, stat, ls) with fallbacks

#### Optional Dependencies
- **Homebrew** (macOS) - Package management
- **Xcode Command Line Tools** (macOS) - Development utilities
- **Modern Bash** (4.x+) - Enhanced features (falls back to 3.x)

### Compatibility

#### Operating Systems
- ✅ **macOS** 10.15+ (Catalina and later)
  - Intel and Apple Silicon (M1/M2) processors
  - Bash 3.2+ (default) and 4.x+ (Homebrew)
  - System Integrity Protection (SIP) enabled/disabled
- ✅ **Linux** distributions
  - Ubuntu/Debian (apt)
  - CentOS/RHEL/Fedora (yum/dnf)
  - Arch Linux (pacman)
  - Alpine Linux (apk)
- ✅ **BSD** variants
  - FreeBSD (pkg)
  - OpenBSD (pkg_add)
  - NetBSD

#### Shells
- ✅ **Bash** 3.2+ (macOS default) and 4.x+ (modern)
- ✅ **Zsh** (macOS default since Catalina)
- ✅ **Fish** (with completion support)

### Migration Notes

#### From Version 1.x
- **Configuration location changed** to `~/.config/compresspdf/config`
- **New command-line options** available (see `--help`)
- **Enhanced output format** with better progress indication
- **Completion scripts** need reinstallation for new features

#### Installation Path Changes
- **Script location**: Follows OS conventions (`/usr/local/bin` or `~/.local/bin`)
- **Completion files**: OS-specific locations with automatic detection
- **Configuration**: XDG Base Directory compliant

### Known Issues

#### Limitations
- **Large PDF files** (>1GB) may require significant processing time
- **Complex PDF structures** might not compress as effectively
- **Encrypted PDFs** require manual decryption before processing

#### Workarounds
- Use `--dry-run` to preview operations on large files
- Check available disk space before processing large files
- Consider page range extraction for very large documents

---

## [1.0.0] - Previous Version

### Initial Release
- Basic PDF compression functionality
- Simple command-line interface
- Ghostscript integration
- Basic error handling

---

## Versioning Strategy

This project uses [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality in a backwards compatible manner  
- **PATCH** version for backwards compatible bug fixes

## Contributing

Please read our contributing guidelines and ensure all changes are documented in this changelog.

## Support

For support and bug reports, please visit our [GitHub repository](https://github.com/asiellb/compresspdf).