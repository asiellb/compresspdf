# compresspdf

Professional PDF compression tool using Ghostscript

## Quick Start

```bash
# Install
make install

# Basic usage
compresspdf document.pdf

# Advanced usage
compresspdf -s printer -l a4 -g document.pdf
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
- **Intelligent autocompletion** for all supported shells
- **Robust error handling** and logging
- **Cross-platform compatibility** (macOS, Linux, Unix)
- **Configurable defaults** via config file

## License

MIT License - see [LICENSE](LICENSE) file.