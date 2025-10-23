# compresspdf

Professional PDF compression tool using Ghostscript

## Quick Start

```bash
# Install (one-line installation)
curl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh | bash -s install

# Or using make
make install

# Basic usage
compresspdf document.pdf

# Advanced usage
compresspdf -s printer -l a4 -g document.pdf

# macOS: Use Quick Actions in Finder (installed automatically)
# Right-click any PDF → Quick Actions → Compress PDF
```

## Project Structure

```
compresspdf/
├── src/                    # Source code
│   └── compresspdf         # Main executable script
├── scripts/                # Installation and utility scripts
│   ├── install.sh          # Installation script
│   └── compresspdf-completion.bash  # Shell completion
├── docs/                   # Documentation
│   ├── README.md           # Detailed documentation
│   └── compresspdf.1       # Man page
├── tests/                  # Test files (future)
├── examples/               # Example files and test data
├── Makefile               # Build and installation tasks
└── LICENSE                # License file
```

## Installation

```bash
# System-wide installation (requires sudo)
make install

# User installation
make install-user

# With completion support
make install-completion
```

## Documentation

See [docs/README.md](docs/README.md) for complete documentation.

## Features

- **Professional compression** with 5 quality levels
- **Multiple page formats** (Letter, A4, Legal)
- **Advanced options** (grayscale, metadata cleaning, page ranges)
- **macOS Quick Actions** for Finder integration (right-click on PDFs)
- **Intelligent autocompletion** for Bash, Zsh, and Fish shells
- **Robust error handling** and logging
- **Cross-platform compatibility** (macOS, Linux, Unix)
- **Configurable defaults** via config file

## License

MIT License - see [LICENSE](LICENSE) file.