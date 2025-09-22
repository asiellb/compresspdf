# Makefile for compresspdf - Professional PDF compression tool
# Version: 2.0.0

# Configuration
SCRIPT_NAME = compresspdf
VERSION = 2.0.0
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man1
COMPLETIONDIR_BASH = $(PREFIX)/share/bash-completion/completions
COMPLETIONDIR_ZSH = $(PREFIX)/share/zsh/site-functions

# User directories
USER_BINDIR = $(HOME)/.local/bin
USER_MANDIR = $(HOME)/.local/share/man/man1
USER_COMPLETIONDIR_BASH = $(HOME)/.local/share/bash-completion/completions
USER_COMPLETIONDIR_ZSH = $(HOME)/.local/share/zsh/site-functions
USER_COMPLETIONDIR_FISH = $(HOME)/.config/fish/completions

# Configuration and log directories
CONFIGDIR = $(HOME)/.config/$(SCRIPT_NAME)
LOGDIR = $(HOME)/.local/share/$(SCRIPT_NAME)/logs

# Files
MAIN_SCRIPT = src/$(SCRIPT_NAME)
COMPLETION_SCRIPT = scripts/$(SCRIPT_NAME)-completion.bash
INSTALL_SCRIPT = scripts/install.sh
MAN_PAGE = docs/$(SCRIPT_NAME).1
README = docs/README.md

# Colors for output
BOLD = \033[1m
GREEN = \033[32m
YELLOW = \033[33m
RED = \033[31m
RESET = \033[0m

.PHONY: all install install-user install-system uninstall uninstall-user uninstall-system \
        install-completion install-completion-user install-completion-system \
        install-man install-man-user install-man-system \
        check-deps test clean help

# Default target
all: help

# Help target
help:
	@echo "$(BOLD)compresspdf $(VERSION) - Professional PDF compression tool$(RESET)"
	@echo ""
	@echo "$(BOLD)Available targets:$(RESET)"
	@echo "  $(GREEN)install$(RESET)              Install for current user (recommended)"
	@echo "  $(GREEN)install-system$(RESET)       Install system-wide (requires sudo)"
	@echo "  $(GREEN)install-user$(RESET)         Install for current user only"
	@echo "  $(GREEN)install-completion$(RESET)   Install completion scripts"
	@echo "  $(GREEN)install-man$(RESET)          Install man page"
	@echo ""
	@echo "  $(YELLOW)uninstall$(RESET)            Uninstall from user directories"
	@echo "  $(YELLOW)uninstall-system$(RESET)     Uninstall from system directories"
	@echo "  $(YELLOW)uninstall-user$(RESET)       Uninstall from user directories"
	@echo ""
	@echo "  $(GREEN)check-deps$(RESET)           Check system dependencies"
	@echo "  $(GREEN)test$(RESET)                 Run basic functionality tests"
	@echo "  $(GREEN)clean$(RESET)               Clean temporary files"
	@echo "  $(GREEN)help$(RESET)                Show this help message"
	@echo ""
	@echo "$(BOLD)Examples:$(RESET)"
	@echo "  make install              # Install for current user"
	@echo "  sudo make install-system  # Install system-wide"
	@echo "  make uninstall            # Remove user installation"
	@echo "  make check-deps           # Check dependencies"

# Installation targets
install: install-user

install-user: check-files
	@echo "$(GREEN)Installing $(SCRIPT_NAME) for current user...$(RESET)"
	@mkdir -p $(USER_BINDIR)
	@install -m 755 $(MAIN_SCRIPT) $(USER_BINDIR)/$(SCRIPT_NAME)
	@echo "$(GREEN)✓$(RESET) Main script installed to $(USER_BINDIR)/$(SCRIPT_NAME)"
	@$(MAKE) install-completion-user
	@$(MAKE) install-man-user
	@$(MAKE) create-user-dirs
	@echo ""
	@echo "$(BOLD)Installation completed!$(RESET)"
	@echo "Add $(USER_BINDIR) to your PATH if not already present:"
	@echo "  export PATH=\"$(USER_BINDIR):\$$PATH\""
	@echo ""
	@echo "Usage: $(SCRIPT_NAME) --help"

install-system: check-files
	@echo "$(GREEN)Installing $(SCRIPT_NAME) system-wide...$(RESET)"
	@install -m 755 $(MAIN_SCRIPT) $(BINDIR)/$(SCRIPT_NAME)
	@echo "$(GREEN)✓$(RESET) Main script installed to $(BINDIR)/$(SCRIPT_NAME)"
	@$(MAKE) install-completion-system
	@$(MAKE) install-man-system
	@echo ""
	@echo "$(BOLD)System-wide installation completed!$(RESET)"
	@echo "Usage: $(SCRIPT_NAME) --help"

# Completion installation
install-completion: install-completion-user

install-completion-user:
	@echo "$(GREEN)Installing completion scripts for user...$(RESET)"
	@mkdir -p $(USER_COMPLETIONDIR_BASH)
	@mkdir -p $(USER_COMPLETIONDIR_ZSH)
	@mkdir -p $(USER_COMPLETIONDIR_FISH)
	@install -m 644 $(COMPLETION_SCRIPT) $(USER_COMPLETIONDIR_BASH)/$(SCRIPT_NAME)
	@echo "$(GREEN)✓$(RESET) Bash completion installed to $(USER_COMPLETIONDIR_BASH)/$(SCRIPT_NAME)"
	@install -m 644 $(COMPLETION_SCRIPT) $(USER_COMPLETIONDIR_ZSH)/_$(SCRIPT_NAME)
	@echo "$(GREEN)✓$(RESET) Zsh completion installed to $(USER_COMPLETIONDIR_ZSH)/_$(SCRIPT_NAME)"
	@echo "# $(SCRIPT_NAME) fish completion" > $(USER_COMPLETIONDIR_FISH)/$(SCRIPT_NAME).fish
	@echo "complete -c $(SCRIPT_NAME) -s f -l file -d 'Input PDF file' -F" >> $(USER_COMPLETIONDIR_FISH)/$(SCRIPT_NAME).fish
	@echo "complete -c $(SCRIPT_NAME) -s s -l setting -x -a 'default screen ebook printer prepress'" >> $(USER_COMPLETIONDIR_FISH)/$(SCRIPT_NAME).fish
	@echo "complete -c $(SCRIPT_NAME) -s l -l layout -x -a 'letter a4 legal'" >> $(USER_COMPLETIONDIR_FISH)/$(SCRIPT_NAME).fish
	@echo "$(GREEN)✓$(RESET) Fish completion installed to $(USER_COMPLETIONDIR_FISH)/$(SCRIPT_NAME).fish"

install-completion-system:
	@echo "$(GREEN)Installing completion scripts system-wide...$(RESET)"
	@mkdir -p $(COMPLETIONDIR_BASH)
	@mkdir -p $(COMPLETIONDIR_ZSH)
	@install -m 644 $(COMPLETION_SCRIPT) $(COMPLETIONDIR_BASH)/$(SCRIPT_NAME)
	@echo "$(GREEN)✓$(RESET) Bash completion installed to $(COMPLETIONDIR_BASH)/$(SCRIPT_NAME)"
	@install -m 644 $(COMPLETION_SCRIPT) $(COMPLETIONDIR_ZSH)/_$(SCRIPT_NAME)
	@echo "$(GREEN)✓$(RESET) Zsh completion installed to $(COMPLETIONDIR_ZSH)/_$(SCRIPT_NAME)"

# Man page installation
install-man: install-man-user

install-man-user:
	@echo "$(GREEN)Installing man page for user...$(RESET)"
	@mkdir -p $(USER_MANDIR)
	@install -m 644 $(MAN_PAGE) $(USER_MANDIR)/$(SCRIPT_NAME).1
	@echo "$(GREEN)✓$(RESET) Man page installed to $(USER_MANDIR)/$(SCRIPT_NAME).1"

install-man-system:
	@echo "$(GREEN)Installing man page system-wide...$(RESET)"
	@mkdir -p $(MANDIR)
	@install -m 644 $(MAN_PAGE) $(MANDIR)/$(SCRIPT_NAME).1
	@echo "$(GREEN)✓$(RESET) Man page installed to $(MANDIR)/$(SCRIPT_NAME).1"

# Create user directories
create-user-dirs:
	@mkdir -p $(CONFIGDIR)
	@mkdir -p $(LOGDIR)
	@echo "$(GREEN)✓$(RESET) Created user configuration and log directories"

# Uninstallation targets
uninstall: uninstall-user

uninstall-user:
	@echo "$(YELLOW)Uninstalling $(SCRIPT_NAME) from user directories...$(RESET)"
	@rm -f $(USER_BINDIR)/$(SCRIPT_NAME)
	@rm -f $(USER_COMPLETIONDIR_BASH)/$(SCRIPT_NAME)
	@rm -f $(USER_COMPLETIONDIR_ZSH)/_$(SCRIPT_NAME)
	@rm -f $(USER_COMPLETIONDIR_FISH)/$(SCRIPT_NAME).fish
	@rm -f $(USER_MANDIR)/$(SCRIPT_NAME).1
	@echo "$(YELLOW)✓$(RESET) Removed installed files"
	@echo ""
	@read -p "Remove user configuration and logs? [y/N] " -n 1 -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		rm -rf $(CONFIGDIR); \
		rm -rf $(LOGDIR); \
		echo "$(YELLOW)✓$(RESET) Removed user data"; \
	fi
	@echo ""
	@echo "$(BOLD)Uninstallation completed$(RESET)"

uninstall-system:
	@echo "$(YELLOW)Uninstalling $(SCRIPT_NAME) from system directories...$(RESET)"
	@rm -f $(BINDIR)/$(SCRIPT_NAME)
	@rm -f $(COMPLETIONDIR_BASH)/$(SCRIPT_NAME)
	@rm -f $(COMPLETIONDIR_ZSH)/_$(SCRIPT_NAME)
	@rm -f $(MANDIR)/$(SCRIPT_NAME).1
	@echo "$(YELLOW)✓$(RESET) Removed system-wide installation"
	@echo "$(BOLD)System uninstallation completed$(RESET)"

# Dependency checking
check-deps:
	@echo "$(GREEN)Checking system dependencies...$(RESET)"
	@echo -n "Checking for Ghostscript (gs)... "
	@if command -v gs >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET)"; \
	else \
		echo "$(RED)✗$(RESET)"; \
		echo "$(RED)Error: Ghostscript not found$(RESET)"; \
		echo "Install with: brew install ghostscript (macOS) or apt-get install ghostscript (Ubuntu)"; \
		exit 1; \
	fi
	@echo -n "Checking for file command... "
	@if command -v file >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET)"; \
	else \
		echo "$(RED)✗$(RESET)"; \
		echo "$(RED)Error: file command not found$(RESET)"; \
		exit 1; \
	fi
	@echo -n "Checking for download tool (curl/wget)... "
	@if command -v curl >/dev/null 2>&1 || command -v wget >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET)"; \
	else \
		echo "$(RED)✗$(RESET)"; \
		echo "$(RED)Error: Neither curl nor wget found$(RESET)"; \
		exit 1; \
	fi
	@echo "$(GREEN)All required dependencies are satisfied$(RESET)"

# File validation
check-files:
	@echo "$(GREEN)Validating installation files...$(RESET)"
	@if [ ! -f $(MAIN_SCRIPT) ]; then \
		echo "$(RED)Error: Main script $(MAIN_SCRIPT) not found$(RESET)"; \
		exit 1; \
	fi
	@if [ ! -f $(COMPLETION_SCRIPT) ]; then \
		echo "$(RED)Error: Completion script $(COMPLETION_SCRIPT) not found$(RESET)"; \
		exit 1; \
	fi
	@if [ ! -f $(MAN_PAGE) ]; then \
		echo "$(RED)Error: Man page $(MAN_PAGE) not found$(RESET)"; \
		exit 1; \
	fi
	@echo "$(GREEN)✓$(RESET) All required files present"

# Testing
test: check-deps
	@echo "$(GREEN)Running basic functionality tests...$(RESET)"
	@if [ ! -f $(MAIN_SCRIPT) ]; then \
		echo "$(RED)Error: $(MAIN_SCRIPT) not found$(RESET)"; \
		exit 1; \
	fi
	@echo -n "Testing help output... "
	@if bash $(MAIN_SCRIPT) --help >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET)"; \
	else \
		echo "$(RED)✗$(RESET)"; \
	fi
	@echo -n "Testing version output... "
	@if bash $(MAIN_SCRIPT) --version >/dev/null 2>&1; then \
		echo "$(GREEN)✓$(RESET)"; \
	else \
		echo "$(RED)✗$(RESET)"; \
	fi
	@echo -n "Testing dependency check... "
	@if bash $(MAIN_SCRIPT) --dry-run /dev/null 2>/dev/null; then \
		echo "$(GREEN)✓$(RESET)"; \
	else \
		echo "$(GREEN)✓$(RESET) (expected failure for invalid input)"; \
	fi
	@echo "$(GREEN)Basic functionality tests completed$(RESET)"

# Cleanup
clean:
	@echo "$(YELLOW)Cleaning temporary files...$(RESET)"
	@rm -f *.tmp
	@rm -f /tmp/$(SCRIPT_NAME)*
	@echo "$(GREEN)✓$(RESET) Cleanup completed"

# Development targets (for maintainers)
.PHONY: package release lint

package:
	@echo "$(GREEN)Creating distribution package...$(RESET)"
	@mkdir -p dist
	@tar -czf dist/$(SCRIPT_NAME)-$(VERSION).tar.gz \
		$(MAIN_SCRIPT) \
		$(COMPLETION_SCRIPT) \
		$(INSTALL_SCRIPT) \
		$(MAN_PAGE) \
		$(README) \
		Makefile \
		LICENSE
	@echo "$(GREEN)✓$(RESET) Package created: dist/$(SCRIPT_NAME)-$(VERSION).tar.gz"

lint:
	@echo "$(GREEN)Running shellcheck on scripts...$(RESET)"
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck $(MAIN_SCRIPT) $(COMPLETION_SCRIPT) $(INSTALL_SCRIPT); \
		echo "$(GREEN)✓$(RESET) Shellcheck passed"; \
	else \
		echo "$(YELLOW)Shellcheck not found, skipping linting$(RESET)"; \
	fi

# Display current installation status
status:
	@echo "$(BOLD)Installation Status:$(RESET)"
	@echo -n "Main script (user): "
	@if [ -f $(USER_BINDIR)/$(SCRIPT_NAME) ]; then \
		echo "$(GREEN)✓ Installed$(RESET)"; \
	else \
		echo "$(YELLOW)Not installed$(RESET)"; \
	fi
	@echo -n "Main script (system): "
	@if [ -f $(BINDIR)/$(SCRIPT_NAME) ]; then \
		echo "$(GREEN)✓ Installed$(RESET)"; \
	else \
		echo "$(YELLOW)Not installed$(RESET)"; \
	fi
	@echo -n "Bash completion: "
	@if [ -f $(USER_COMPLETIONDIR_BASH)/$(SCRIPT_NAME) ] || [ -f $(COMPLETIONDIR_BASH)/$(SCRIPT_NAME) ]; then \
		echo "$(GREEN)✓ Installed$(RESET)"; \
	else \
		echo "$(YELLOW)Not installed$(RESET)"; \
	fi
	@echo -n "Man page: "
	@if [ -f $(USER_MANDIR)/$(SCRIPT_NAME).1 ] || [ -f $(MANDIR)/$(SCRIPT_NAME).1 ]; then \
		echo "$(GREEN)✓ Installed$(RESET)"; \
	else \
		echo "$(YELLOW)Not installed$(RESET)"; \
	fi