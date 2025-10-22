#!/bin/bash

# Enhanced installation script for compresspdf
# Version: 2.0.0
# 
# This script handles installation, updating, and removal of compresspdf
# with proper dependency checking and error handling.

set -euo pipefail
IFS=$'\n\t'

# =============================================================================
# CONSTANTS
# =============================================================================

readonly SCRIPT_NAME="compresspdf"
readonly SCRIPT_VERSION="2.0.0"
readonly SCRIPT_REPO="https://github.com/asiellb/compresspdf"
readonly SCRIPT_URL="https://raw.githubusercontent.com/asiellb/compresspdf/master/src/compresspdf"
readonly COMPLETION_URL="https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/compresspdf-completion.bash"
readonly FISH_COMPLETION_URL="https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/compresspdf-completion.fish"

# Installation paths (will be configured by configure_install_paths)
INSTALL_DIR="/usr/local/bin"
INSTALL_PATH=""
readonly TEMP_DIR="/tmp"
readonly TEMP_SCRIPT="${TEMP_DIR}/${SCRIPT_NAME}.tmp"
readonly TEMP_COMPLETION="${TEMP_DIR}/${SCRIPT_NAME}-completion.tmp"
readonly TEMP_FISH_COMPLETION="${TEMP_DIR}/${SCRIPT_NAME}-completion-fish.tmp"

# User installation paths
readonly USER_INSTALL_DIR="${HOME}/.local/bin"
USER_INSTALL_PATH=""

# Completion paths (will be updated by get_os_paths)
BASH_COMPLETION_SYSTEM="/etc/bash_completion.d"
BASH_COMPLETION_SYSTEM_ALT="/usr/share/bash-completion/completions"
ZSH_COMPLETION_SYSTEM="/usr/share/zsh/site-functions"

# User completion paths
readonly BASH_COMPLETION_USER="${HOME}/.local/share/bash-completion/completions"
readonly ZSH_COMPLETION_USER="${HOME}/.local/share/zsh/site-functions"
readonly FISH_COMPLETION_USER="${HOME}/.config/fish/completions"

# Configuration
readonly CONFIG_DIR="${HOME}/.config/${SCRIPT_NAME}"
readonly LOG_DIR="${HOME}/.local/share/${SCRIPT_NAME}/logs"

# Colors (compatible with Bash 3.x)
COLOR_RED=""
COLOR_GREEN=""
COLOR_YELLOW=""
COLOR_BLUE=""
COLOR_BOLD=""
COLOR_RESET=""

# OS Detection variables
OS_TYPE=""
OS_VERSION=""
PACKAGE_MANAGER=""

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Initialize colors
init_colors() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        local colors
        colors=$(tput colors 2>/dev/null || echo "0")
        if [[ ${colors} -ge 8 ]]; then
            COLOR_RED=$(tput setaf 1)
            COLOR_GREEN=$(tput setaf 2)
            COLOR_YELLOW=$(tput setaf 3)
            COLOR_BLUE=$(tput setaf 4)
            COLOR_BOLD=$(tput bold)
            COLOR_RESET=$(tput sgr0)
        fi
    fi
}

# Logging functions
log_info() {
    echo "${COLOR_GREEN}[INFO]${COLOR_RESET} $*"
}

log_warning() {
    echo "${COLOR_YELLOW}[WARNING]${COLOR_RESET} $*" >&2
}

log_error() {
    echo "${COLOR_RED}[ERROR]${COLOR_RESET} $*" >&2
}

log_fatal() {
    echo "${COLOR_RED}${COLOR_BOLD}[FATAL]${COLOR_RESET} $*" >&2
    exit 1
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running as root
is_root() {
    [[ ${EUID} -eq 0 ]]
}

# Detect operating system and package manager
detect_os() {
    # Detect OS type
    if [[ -f /etc/os-release ]]; then
        # Most modern Linux distributions
        . /etc/os-release
        OS_TYPE="${ID:-unknown}"
        OS_VERSION="${VERSION_ID:-unknown}"
    elif command_exists sw_vers; then
        # macOS
        OS_TYPE="macos"
        OS_VERSION=$(sw_vers -productVersion)
    elif [[ -f /etc/redhat-release ]]; then
        # Older RHEL/CentOS
        OS_TYPE="rhel"
        OS_VERSION=$(cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+')
    elif [[ -f /etc/debian_version ]]; then
        # Debian-based
        OS_TYPE="debian"
        OS_VERSION=$(cat /etc/debian_version)
    elif command_exists uname; then
        # Fallback to uname
        local uname_s=$(uname -s)
        case "${uname_s}" in
            Darwin*)  OS_TYPE="macos" ;;
            Linux*)   OS_TYPE="linux" ;;
            FreeBSD*) OS_TYPE="freebsd" ;;
            OpenBSD*) OS_TYPE="openbsd" ;;
            NetBSD*)  OS_TYPE="netbsd" ;;
            *)        OS_TYPE="unknown" ;;
        esac
        OS_VERSION=$(uname -r)
    else
        OS_TYPE="unknown"
        OS_VERSION="unknown"
    fi

    # Detect package manager
    if command_exists brew; then
        PACKAGE_MANAGER="brew"
    elif command_exists apt-get; then
        PACKAGE_MANAGER="apt"
    elif command_exists dnf; then
        PACKAGE_MANAGER="dnf"
    elif command_exists yum; then
        PACKAGE_MANAGER="yum"
    elif command_exists pacman; then
        PACKAGE_MANAGER="pacman"
    elif command_exists apk; then
        PACKAGE_MANAGER="apk"
    elif command_exists pkg; then
        PACKAGE_MANAGER="pkg"  # FreeBSD
    elif command_exists pkg_add; then
        PACKAGE_MANAGER="pkg_add"  # OpenBSD
    else
        PACKAGE_MANAGER="unknown"
    fi
}

# Get OS-specific paths
get_os_paths() {
    case "${OS_TYPE}" in
        macos)
            # macOS specific paths
            if command_exists brew; then
                local brew_prefix=$(brew --prefix 2>/dev/null || echo "/usr/local")
                BASH_COMPLETION_SYSTEM="${brew_prefix}/etc/bash_completion.d"
                ZSH_COMPLETION_SYSTEM="${brew_prefix}/share/zsh/site-functions"
            else
                BASH_COMPLETION_SYSTEM="/usr/local/etc/bash_completion.d"
                ZSH_COMPLETION_SYSTEM="/usr/local/share/zsh/site-functions"
            fi
            ;;
        *)
            # Use default Linux paths (already set in constants)
            ;;
    esac
}

# Check if SIP is enabled on macOS
is_sip_enabled() {
    if [[ "${OS_TYPE}" == "macos" ]] && command_exists csrutil; then
        local sip_status=$(csrutil status 2>/dev/null)
        if [[ "${sip_status}" =~ "enabled" ]]; then
            return 0
        fi
    fi
    return 1
}

# Check if we should prefer user installation
should_prefer_user_install() {
    # For macOS with SIP enabled, prefer user installation
    if [[ "${OS_TYPE}" == "macos" ]] && is_sip_enabled; then
        return 0
    fi
    
    # If /usr/local/bin is not writable and we're not root
    if [[ ! -w "/usr/local/bin" ]] && ! is_root; then
        return 0
    fi
    
    return 1
}

# Configure installation paths based on OS and user preference
configure_install_paths() {
    local user_install=false
    
    # Check if we should prefer user installation
    if should_prefer_user_install; then
        user_install=true
        log_info "Detected macOS with SIP enabled or insufficient permissions, using user installation"
    fi
    
    # Set installation paths
    if [[ "${user_install}" == "true" ]]; then
        INSTALL_DIR="${USER_INSTALL_DIR}"
        INSTALL_PATH="${USER_INSTALL_DIR}/${SCRIPT_NAME}"
        USER_INSTALL_PATH="${USER_INSTALL_DIR}/${SCRIPT_NAME}"
    else
        INSTALL_PATH="${INSTALL_DIR}/${SCRIPT_NAME}"
        USER_INSTALL_PATH="${USER_INSTALL_DIR}/${SCRIPT_NAME}"
    fi
    
    # Create installation directory if needed
    if [[ ! -d "${INSTALL_DIR}" ]]; then
        create_directory "${INSTALL_DIR}" "installation directory"
    fi
}

# Check if file is writable (considering sudo)
is_writable() {
    local file="$1"
    local dir
    dir=$(dirname "${file}")
    
    if [[ -f "${file}" ]]; then
        [[ -w "${file}" ]]
    elif [[ -d "${dir}" ]]; then
        [[ -w "${dir}" ]]
    else
        false
    fi
}

# Download file with error handling
download_file() {
    local url="$1"
    local output="$2"
    local description="${3:-file}"
    
    log_info "Downloading ${description}..."
    
    if command_exists curl; then
        if ! curl -fsSL "${url}" -o "${output}"; then
            log_error "Failed to download ${description} using curl"
            return 1
        fi
    elif command_exists wget; then
        if ! wget -q "${url}" -O "${output}"; then
            log_error "Failed to download ${description} using wget"
            return 1
        fi
    else
        log_fatal "Neither curl nor wget is available for downloading"
    fi
    
    log_info "${description} downloaded successfully"
    return 0
}

# Create directory with proper permissions
create_directory() {
    local dir="$1"
    local description="${2:-directory}"
    
    if [[ ! -d "${dir}" ]]; then
        log_info "Creating ${description}: ${dir}"
        if ! mkdir -p "${dir}"; then
            log_error "Failed to create ${description}: ${dir}"
            return 1
        fi
    fi
    return 0
}

# =============================================================================
# DEPENDENCY CHECKING
# =============================================================================

check_dependencies() {
    log_info "Checking system dependencies..."
    
    # Detect OS if not already done
    if [[ -z "${OS_TYPE}" ]]; then
        detect_os
    fi
    
    local missing_deps=()
    local warnings=()
    
    # Required dependencies
    if ! command_exists gs; then
        missing_deps+=("ghostscript")
    fi
    
    if ! command_exists file; then
        missing_deps+=("file")
    fi
    
    # Download tools (at least one required)
    if ! command_exists curl && ! command_exists wget; then
        missing_deps+=("curl or wget")
    fi
    
    # macOS specific checks
    if [[ "${OS_TYPE}" == "macos" ]]; then
        # Check for Xcode Command Line Tools
        if ! command_exists xcode-select || ! xcode-select -p >/dev/null 2>&1; then
            warnings+=("Xcode Command Line Tools (for development tools)")
        fi
        
        # Check for Homebrew (recommended for macOS)
        if ! command_exists brew; then
            warnings+=("Homebrew (recommended package manager for macOS)")
        fi
        
        # Check Bash version (macOS default is often old)
        local bash_version=""
        if command_exists bash; then
            bash_version=$(bash --version | head -1 | grep -oE '[0-9]+\.[0-9]+')
            local bash_major=$(echo "${bash_version}" | cut -d. -f1)
            if [[ "${bash_major}" -lt 4 ]]; then
                warnings+=("Bash 4+ (current: ${bash_version}, consider: brew install bash)")
            fi
        fi
        
        # macOS has these tools built-in, no need to warn
    else
        # Optional but recommended for other systems
        if ! command_exists du; then
            warnings+=("du (for file size calculations)")
        fi
        
        if ! command_exists stat; then
            warnings+=("stat (for file information)")
        fi
    fi
    
    # Report missing dependencies
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        log_error "Missing required dependencies:"
        for dep in "${missing_deps[@]}"; do
            echo "  - ${dep}"
        done
        echo
        show_dependency_install_instructions
        return 1
    fi
    
    # Report warnings
    if [[ ${#warnings[@]} -gt 0 ]]; then
        log_warning "Missing optional dependencies (recommended):"
        for warning in "${warnings[@]}"; do
            echo "  - ${warning}"
        done
        echo
        
        # macOS specific installation suggestions
        if [[ "${OS_TYPE}" == "macos" ]]; then
            if [[ " ${warnings[*]} " =~ "Xcode Command Line Tools" ]]; then
                echo "${COLOR_BOLD}To install Xcode Command Line Tools:${COLOR_RESET}"
                echo "  xcode-select --install"
                echo
            fi
            
            if [[ " ${warnings[*]} " =~ "Homebrew" ]]; then
                echo "${COLOR_BOLD}To install Homebrew:${COLOR_RESET}"
                echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                echo
            fi
            
            if [[ " ${warnings[*]} " =~ "Bash 4+" ]]; then
                echo "${COLOR_BOLD}To install modern Bash:${COLOR_RESET}"
                echo "  brew install bash"
                echo "  # Add /usr/local/bin/bash to /etc/shells"
                echo "  # Then: chsh -s /usr/local/bin/bash"
                echo
            fi
        fi
    fi
    
    log_info "All required dependencies are satisfied"
    return 0
}

show_dependency_install_instructions() {
    # Detect OS if not already done
    if [[ -z "${OS_TYPE}" ]]; then
        detect_os
    fi
    
    echo "${COLOR_BOLD}Installation instructions for missing dependencies:${COLOR_RESET}"
    echo
    
    # Show OS-specific instructions first
    case "${OS_TYPE}" in
        macos)
            echo "${COLOR_BOLD}${COLOR_GREEN}For your system (macOS):${COLOR_RESET}"
            if command_exists brew; then
                echo "  ${COLOR_BOLD}Using Homebrew (recommended):${COLOR_RESET}"
                echo "    brew install ghostscript"
            else
                echo "  ${COLOR_BOLD}Install Homebrew first:${COLOR_RESET}"
                echo "    /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
                echo "  ${COLOR_BOLD}Then install dependencies:${COLOR_RESET}"
                echo "    brew install ghostscript"
            fi
            if command_exists port; then
                echo "  ${COLOR_BOLD}Using MacPorts (alternative):${COLOR_RESET}"
                echo "    sudo port install ghostscript9"
            fi
            echo "  ${COLOR_BOLD}Manual installation:${COLOR_RESET}"
            echo "    Download from: https://www.ghostscript.com/download/gsdnld.html"
            ;;
        ubuntu|debian)
            echo "${COLOR_BOLD}${COLOR_GREEN}For your system (${OS_TYPE^}):${COLOR_RESET}"
            echo "    sudo apt-get update"
            echo "    sudo apt-get install ghostscript file curl"
            ;;
        rhel|centos|fedora)
            echo "${COLOR_BOLD}${COLOR_GREEN}For your system (${OS_TYPE^}):${COLOR_RESET}"
            if [[ "${PACKAGE_MANAGER}" == "dnf" ]]; then
                echo "    sudo dnf install ghostscript file curl"
            else
                echo "    sudo yum install ghostscript file curl"
            fi
            ;;
        arch)
            echo "${COLOR_BOLD}${COLOR_GREEN}For your system (Arch Linux):${COLOR_RESET}"
            echo "    sudo pacman -S ghostscript file curl"
            ;;
        alpine)
            echo "${COLOR_BOLD}${COLOR_GREEN}For your system (Alpine Linux):${COLOR_RESET}"
            echo "    sudo apk add ghostscript file curl"
            ;;
        freebsd)
            echo "${COLOR_BOLD}${COLOR_GREEN}For your system (FreeBSD):${COLOR_RESET}"
            echo "    sudo pkg install ghostscript9-agpl-nox11 curl"
            ;;
        openbsd)
            echo "${COLOR_BOLD}${COLOR_GREEN}For your system (OpenBSD):${COLOR_RESET}"
            echo "    sudo pkg_add ghostscript curl"
            ;;
        *)
            echo "${COLOR_YELLOW}Could not detect your specific OS. Try one of the following:${COLOR_RESET}"
            ;;
    esac
    
    echo
    echo "${COLOR_BOLD}Other systems:${COLOR_RESET}"
    echo
    echo "${COLOR_BOLD}macOS (Homebrew):${COLOR_RESET}"
    echo "  brew install ghostscript"
    echo
    echo "${COLOR_BOLD}Ubuntu/Debian:${COLOR_RESET}"
    echo "  sudo apt-get update && sudo apt-get install ghostscript file curl"
    echo
    echo "${COLOR_BOLD}CentOS/RHEL/Fedora:${COLOR_RESET}"
    echo "  sudo dnf install ghostscript file curl  # (or yum on older versions)"
    echo
    echo "${COLOR_BOLD}Arch Linux:${COLOR_RESET}"
    echo "  sudo pacman -S ghostscript file curl"
    echo
    echo "${COLOR_BOLD}Alpine Linux:${COLOR_RESET}"
    echo "  sudo apk add ghostscript file curl"
    echo
    echo "${COLOR_BOLD}FreeBSD:${COLOR_RESET}"
    echo "  sudo pkg install ghostscript9-agpl-nox11 curl"
    echo
    echo "For other systems, please install Ghostscript from:"
    echo "${COLOR_BLUE}https://www.ghostscript.com/download/gsdnld.html${COLOR_RESET}"
    echo
}

# =============================================================================
# INSTALLATION FUNCTIONS
# =============================================================================

install_main_script() {
    log_info "Installing ${SCRIPT_NAME} to ${INSTALL_PATH}..."
    
    # Download main script
    if ! download_file "${SCRIPT_URL}" "${TEMP_SCRIPT}" "main script"; then
        return 1
    fi
    
    # Verify downloaded script
    if [[ ! -s "${TEMP_SCRIPT}" ]]; then
        log_error "Downloaded script is empty"
        return 1
    fi
    
    # Check if script needs sudo
    if ! is_writable "${INSTALL_PATH}"; then
        if is_root; then
            log_error "Cannot write to ${INSTALL_PATH} even as root"
            return 1
        else
            log_info "Administrator privileges required for installation"
            if ! sudo cp "${TEMP_SCRIPT}" "${INSTALL_PATH}"; then
                log_error "Failed to install script to ${INSTALL_PATH}"
                return 1
            fi
            if ! sudo chmod +x "${INSTALL_PATH}"; then
                log_error "Failed to make script executable"
                return 1
            fi
        fi
    else
        # Direct installation
        if ! cp "${TEMP_SCRIPT}" "${INSTALL_PATH}"; then
            log_error "Failed to install script to ${INSTALL_PATH}"
            return 1
        fi
        if ! chmod +x "${INSTALL_PATH}"; then
            log_error "Failed to make script executable"
            return 1
        fi
    fi
    
    log_info "Main script installed successfully"
    return 0
}

install_completion_scripts() {
    log_info "Installing completion scripts..."
    
    # Download completion script
    if ! download_file "${COMPLETION_URL}" "${TEMP_COMPLETION}" "completion script"; then
        log_warning "Failed to download completion script, continuing without autocompletion"
        return 0
    fi
    
    # Verify downloaded completion script
    if [[ ! -s "${TEMP_COMPLETION}" ]]; then
        log_warning "Downloaded completion script is empty, skipping autocompletion"
        return 0
    fi
    
    local installed_any=false
    
    # Try to install bash completion
    install_bash_completion && installed_any=true
    
    # Try to install zsh completion
    install_zsh_completion && installed_any=true
    
    # Try to install fish completion
    install_fish_completion && installed_any=true
    
    if [[ ${installed_any} == true ]]; then
        log_info "Completion scripts installed successfully"
        log_info "Restart your shell to enable autocompletion"
    else
        log_warning "Could not install any completion scripts"
        log_info "You can manually install completion by running:"
        log_info "  source ${TEMP_COMPLETION}"
    fi
    
    return 0
}

install_bash_completion() {
    local completion_dirs=("${BASH_COMPLETION_USER}" "${BASH_COMPLETION_SYSTEM}" "${BASH_COMPLETION_SYSTEM_ALT}")
    
    for dir in "${completion_dirs[@]}"; do
        local completion_file="${dir}/${SCRIPT_NAME}"
        
        if [[ "${dir}" == "${BASH_COMPLETION_USER}" ]]; then
            # User installation
            if create_directory "${dir}" "bash completion directory"; then
                if cp "${TEMP_COMPLETION}" "${completion_file}" 2>/dev/null; then
                    log_info "Bash completion installed to: ${completion_file}"
                    return 0
                fi
            fi
        else
            # System installation
            if [[ -d "${dir}" ]] && is_writable "${completion_file}"; then
                if cp "${TEMP_COMPLETION}" "${completion_file}"; then
                    log_info "Bash completion installed to: ${completion_file}"
                    return 0
                fi
            elif [[ -d "${dir}" ]] && ! is_root; then
                if sudo cp "${TEMP_COMPLETION}" "${completion_file}" 2>/dev/null; then
                    log_info "Bash completion installed to: ${completion_file}"
                    return 0
                fi
            fi
        fi
    done
    
    log_warning "Could not install bash completion"
    return 1
}

install_zsh_completion() {
    local completion_dirs=("${ZSH_COMPLETION_USER}" "${ZSH_COMPLETION_SYSTEM}")
    
    for dir in "${completion_dirs[@]}"; do
        local completion_file="${dir}/_${SCRIPT_NAME}"
        
        if [[ "${dir}" == "${ZSH_COMPLETION_USER}" ]]; then
            # User installation
            if create_directory "${dir}" "zsh completion directory"; then
                if cp "${TEMP_COMPLETION}" "${completion_file}" 2>/dev/null; then
                    log_info "Zsh completion installed to: ${completion_file}"
                    log_info "Add to your ~/.zshrc: fpath=(${dir} \$fpath)"
                    return 0
                fi
            fi
        else
            # System installation
            if [[ -d "${dir}" ]] && is_writable "${completion_file}"; then
                if cp "${TEMP_COMPLETION}" "${completion_file}"; then
                    log_info "Zsh completion installed to: ${completion_file}"
                    return 0
                fi
            elif [[ -d "${dir}" ]] && ! is_root; then
                if sudo cp "${TEMP_COMPLETION}" "${completion_file}" 2>/dev/null; then
                    log_info "Zsh completion installed to: ${completion_file}"
                    return 0
                fi
            fi
        fi
    done
    
    log_warning "Could not install zsh completion"
    return 1
}

install_fish_completion() {
    # Install Fish completion if Fish is available
    if command_exists fish; then
        local fish_completion_file="${FISH_COMPLETION_USER}/${SCRIPT_NAME}.fish"
        
        # Download Fish completion script
        if download_file "${FISH_COMPLETION_URL}" "${TEMP_FISH_COMPLETION}" "fish completion script"; then
            if create_directory "${FISH_COMPLETION_USER}" "fish completion directory"; then
                if cp "${TEMP_FISH_COMPLETION}" "${fish_completion_file}" 2>/dev/null; then
                    log_info "Fish completion installed to: ${fish_completion_file}"
                    return 0
                fi
            fi
        fi
        
        log_warning "Could not install fish completion"
    fi
    
    return 1
}

# =============================================================================
# UPDATE FUNCTION
# =============================================================================

update_installation() {
    log_info "Checking for updates..."
    
    # Check if script is already installed
    if [[ ! -f "${INSTALL_PATH}" ]]; then
        log_error "${SCRIPT_NAME} is not installed"
        log_info "Run installation first"
        return 1
    fi
    
    # Check current version
    local current_version
    if current_version=$("${INSTALL_PATH}" --version 2>/dev/null | head -n1 | awk '{print $2}'); then
        log_info "Current version: ${current_version}"
        log_info "Latest version: ${SCRIPT_VERSION}"
        
        if [[ "${current_version}" == "${SCRIPT_VERSION}" ]]; then
            log_info "${SCRIPT_NAME} is already up to date"
            return 0
        fi
    else
        log_warning "Could not determine current version"
    fi
    
    # Perform update
    log_info "Updating ${SCRIPT_NAME}..."
    
    if install_main_script && install_completion_scripts; then
        log_info "Update completed successfully"
        return 0
    else
        log_error "Update failed"
        return 1
    fi
}

# =============================================================================
# UNINSTALL FUNCTION
# =============================================================================

uninstall() {
    log_info "Uninstalling ${SCRIPT_NAME}..."
    
    local removed_files=()
    local failed_files=()
    
    # Remove main script
    if [[ -f "${INSTALL_PATH}" ]]; then
        if is_writable "${INSTALL_PATH}"; then
            if rm -f "${INSTALL_PATH}"; then
                removed_files+=("${INSTALL_PATH}")
            else
                failed_files+=("${INSTALL_PATH}")
            fi
        else
            if sudo rm -f "${INSTALL_PATH}" 2>/dev/null; then
                removed_files+=("${INSTALL_PATH}")
            else
                failed_files+=("${INSTALL_PATH}")
            fi
        fi
    fi
    
    # Remove completion scripts
    local completion_files=(
        "${BASH_COMPLETION_USER}/${SCRIPT_NAME}"
        "${BASH_COMPLETION_SYSTEM}/${SCRIPT_NAME}"
        "${BASH_COMPLETION_SYSTEM_ALT}/${SCRIPT_NAME}"
        "${ZSH_COMPLETION_USER}/_${SCRIPT_NAME}"
        "${ZSH_COMPLETION_SYSTEM}/_${SCRIPT_NAME}"
        "${FISH_COMPLETION_USER}/${SCRIPT_NAME}.fish"
    )
    
    for file in "${completion_files[@]}"; do
        if [[ -f "${file}" ]]; then
            if is_writable "${file}"; then
                if rm -f "${file}"; then
                    removed_files+=("${file}")
                else
                    failed_files+=("${file}")
                fi
            else
                if sudo rm -f "${file}" 2>/dev/null; then
                    removed_files+=("${file}")
                else
                    failed_files+=("${file}")
                fi
            fi
        fi
    done
    
    # Remove user configuration and logs (with confirmation)
    if [[ -d "${CONFIG_DIR}" || -d "${LOG_DIR}" ]]; then
        echo
        read -p "Remove user configuration and logs? [y/N] " -n 1 -r
        echo
        if [[ ${REPLY} =~ ^[Yy]$ ]]; then
            if [[ -d "${CONFIG_DIR}" ]]; then
                if rm -rf "${CONFIG_DIR}"; then
                    removed_files+=("${CONFIG_DIR}")
                else
                    failed_files+=("${CONFIG_DIR}")
                fi
            fi
            if [[ -d "${LOG_DIR}" ]]; then
                if rm -rf "${LOG_DIR}"; then
                    removed_files+=("${LOG_DIR}")
                else
                    failed_files+=("${LOG_DIR}")
                fi
            fi
        fi
    fi
    
    # Report results
    if [[ ${#removed_files[@]} -gt 0 ]]; then
        log_info "Removed files:"
        for file in "${removed_files[@]}"; do
            echo "  - ${file}"
        done
    fi
    
    if [[ ${#failed_files[@]} -gt 0 ]]; then
        log_warning "Failed to remove files:"
        for file in "${failed_files[@]}"; do
            echo "  - ${file}"
        done
        return 1
    fi
    
    log_info "Uninstallation completed successfully"
    return 0
}

# =============================================================================
# MAIN INSTALLATION FUNCTION
# =============================================================================

perform_installation() {
    log_info "Starting ${SCRIPT_NAME} installation..."
    
    # Check if already installed and up to date
    if command_exists "${SCRIPT_NAME}"; then
        local current_version
        if current_version=$("${SCRIPT_NAME}" --version 2>/dev/null | head -n1 | awk '{print $2}'); then
            if [[ "${current_version}" == "${SCRIPT_VERSION}" ]]; then
                log_info "${SCRIPT_NAME} ${current_version} is already installed and up to date"
                return 0
            else
                log_info "Found ${SCRIPT_NAME} ${current_version}, updating to ${SCRIPT_VERSION}..."
                return update_installation
            fi
        fi
    fi
    
    # Perform fresh installation
    if install_main_script && install_completion_scripts; then
        log_info "Installation completed successfully!"
        echo
        log_info "Usage: ${SCRIPT_NAME} --help"
        log_info "Example: ${SCRIPT_NAME} document.pdf"
        echo
        return 0
    else
        log_error "Installation failed"
        return 1
    fi
}

# =============================================================================
# HELP AND USAGE
# =============================================================================

show_help() {
    cat << EOF
${COLOR_BOLD}compresspdf Installation Script${COLOR_RESET}

${COLOR_BOLD}USAGE:${COLOR_RESET}
    ${0##*/} [COMMAND] [OPTIONS]

${COLOR_BOLD}COMMANDS:${COLOR_RESET}
    ${COLOR_BOLD}install${COLOR_RESET}        Install compresspdf (default)
    ${COLOR_BOLD}update${COLOR_RESET}         Update existing installation
    ${COLOR_BOLD}uninstall${COLOR_RESET}      Remove compresspdf completely
    ${COLOR_BOLD}check-deps${COLOR_RESET}     Check system dependencies
    ${COLOR_BOLD}help${COLOR_RESET}           Show this help message

${COLOR_BOLD}OPTIONS:${COLOR_RESET}
    ${COLOR_BOLD}--no-completion${COLOR_RESET}  Skip installation of completion scripts
    ${COLOR_BOLD}--force${COLOR_RESET}         Force installation even if already installed
    ${COLOR_BOLD}--quiet${COLOR_RESET}         Suppress informational output

${COLOR_BOLD}EXAMPLES:${COLOR_RESET}
    # Basic installation
    ${0##*/}
    
    # Update existing installation
    ${0##*/} update
    
    # Check dependencies
    ${0##*/} check-deps
    
    # Uninstall completely
    ${0##*/} uninstall

${COLOR_BOLD}INSTALLATION LOCATIONS:${COLOR_RESET}
    Main script: ${INSTALL_PATH}
    Bash completion: ${BASH_COMPLETION_USER}/${SCRIPT_NAME}
    Zsh completion: ${ZSH_COMPLETION_USER}/_${SCRIPT_NAME}
    Fish completion: ${FISH_COMPLETION_USER}/${SCRIPT_NAME}.fish
    Configuration: ${CONFIG_DIR}
    Logs: ${LOG_DIR}

EOF
}

# =============================================================================
# CLEANUP
# =============================================================================

cleanup() {
    # Remove temporary files
    rm -f "${TEMP_SCRIPT}" "${TEMP_COMPLETION}" "${TEMP_FISH_COMPLETION}" 2>/dev/null || true
}

# =============================================================================
# MAIN FUNCTION
# =============================================================================

main() {
    # Set up cleanup trap
    trap cleanup EXIT
    
    # Initialize
    init_colors
    
    # Detect operating system and configure paths
    detect_os
    get_os_paths
    configure_install_paths
    
    # Parse arguments
    local command="install"
    local skip_completion=false
    local force=false
    local quiet=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            install|update|uninstall|check-deps|help)
                command="$1"
                ;;
            --no-completion)
                skip_completion=true
                ;;
            --force)
                force=true
                ;;
            --quiet)
                quiet=true
                ;;
            -h|--help)
                command="help"
                ;;
            *)
                log_error "Unknown option: $1"
                echo "Use '${0##*/} help' for usage information"
                exit 1
                ;;
        esac
        shift
    done
    
    # Execute command
    case "${command}" in
        install)
            check_dependencies || exit 1
            perform_installation
            ;;
        update)
            check_dependencies || exit 1
            update_installation
            ;;
        uninstall)
            uninstall
            ;;
        check-deps)
            check_dependencies
            ;;
        help)
            show_help
            ;;
        *)
            log_error "Unknown command: ${command}"
            exit 1
            ;;
    esac
}

# =============================================================================
# SCRIPT ENTRY POINT
# =============================================================================

# Only run main function if script is executed directly (not sourced)
# Handle cases where BASH_SOURCE is not available (e.g., when piped from curl)
if [[ "${BASH_SOURCE[0]:-$0}" == "${0}" ]]; then
    main "$@"
fi