# compresspdf Project Structure

This project follows modern software development best practices with a clean directory structure.

## Directory Structure

### `/src/`
Contains the main source code:
- `compresspdf` - Main executable script (Bash)

### `/scripts/`
Utility and installation scripts:
- `install.sh` - Installation script for system/user installation
- `compresspdf-completion.bash` - Shell completion script (Bash/Zsh/Fish compatible)

### `/docs/`
All documentation:
- `README.md` - Comprehensive user documentation with examples
- `compresspdf.1` - Unix manual page for `man compresspdf`

### `/tests/` 
Test files and test data (prepared for future test suite):
- Unit tests (future)
- Integration tests (future)
- Test data files (future)

### `/examples/`
Example files and sample data:
- Sample PDF files for testing
- Configuration examples
- Usage examples

### Root Level
Project metadata and configuration:
- `Makefile` - Build, install, and test automation
- `LICENSE` - MIT license
- `README.md` - Quick start guide and project overview
- `.gitignore` - Git ignore patterns

## Build System

The project uses a `Makefile` for automation:

```bash
make install          # System-wide installation
make install-user     # User-only installation
make install-completion # Install shell completion
make test            # Run tests
make clean           # Clean temporary files
make help            # Show all available targets
```

## Installation Paths

### System Installation (`make install`)
- Binary: `/usr/local/bin/compresspdf`
- Manual: `/usr/local/share/man/man1/compresspdf.1`
- Completion: `/usr/local/share/bash-completion/completions/compresspdf`

### User Installation (`make install-user`)
- Binary: `~/.local/bin/compresspdf`
- Manual: `~/.local/share/man/man1/compresspdf.1`
- Completion: `~/.local/share/bash-completion/completions/compresspdf`

## Configuration Files

Runtime configuration is stored in:
- Config: `~/.config/compresspdf/config`
- Logs: `~/.local/share/compresspdf/logs/compresspdf.log`

## Development

This structure supports:
- Easy maintenance and updates
- Clear separation of concerns
- Professional packaging
- CI/CD integration (future)
- Multiple installation methods
- Cross-platform compatibility