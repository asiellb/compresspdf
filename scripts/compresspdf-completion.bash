#!/bin/bash

# compresspdf bash completion script
# This file provides autocompletion for the compresspdf command
# 
# Installation:
#   - For system-wide: copy to /etc/bash_completion.d/ or /usr/share/bash-completion/completions/
#   - For user: copy to ~/.local/share/bash-completion/completions/ or source in ~/.bashrc
#
# Usage: source this file or install in completion directory

# =============================================================================
# COMPLETION DATA
# =============================================================================

# Valid compression settings
_compresspdf_settings() {
    echo "default screen ebook printer prepress"
}

# Valid page layouts
_compresspdf_layouts() {
    echo "letter a4 legal prepress"
}

# Get PDF files in current directory
_compresspdf_pdf_files() {
    local cur="${1:-}"
    compgen -f -X "!*.pdf" -- "${cur}" 2>/dev/null
}

# Get all files for output option
_compresspdf_all_files() {
    local cur="${1:-}"
    compgen -f -- "${cur}" 2>/dev/null
}

# Get directories
_compresspdf_directories() {
    local cur="${1:-}"
    compgen -d -- "${cur}" 2>/dev/null
}

# =============================================================================
# MAIN COMPLETION FUNCTION
# =============================================================================

_compresspdf_completion() {
    local cur prev words cword
    _init_completion || return

    # Available options
    local short_opts="-f -o -s -l -i -e -g -c -v -q -h -u"
    local long_opts="--file --output --setting --layout --initial --end --grayscale --clean --verbose --quiet --force --dry-run --config --create-config --help --version --update"
    local all_opts="${short_opts} ${long_opts}"

    # Handle specific option arguments
    case "${prev}" in
        -f|--file)
            # Complete with PDF files - use compgen directly for file completion
            COMPREPLY=($(compgen -f -X '!*.pdf' -- "${cur}"))
            return 0
            ;;
        -o|--output)
            # Complete with all files - use compgen directly for file completion
            COMPREPLY=($(compgen -f -- "${cur}"))
            return 0
            ;;
        -s|--setting)
            # Complete with valid settings
            COMPREPLY=($(compgen -W "$(_compresspdf_settings)" -- "${cur}"))
            return 0
            ;;
        -l|--layout)
            # Complete with valid layouts
            COMPREPLY=($(compgen -W "$(_compresspdf_layouts)" -- "${cur}"))
            return 0
            ;;
        -i|--initial|-e|--end)
            # No completion for page numbers (user input required)
            return 0
            ;;
        --config)
            # Complete with config files - use compgen directly for file completion
            COMPREPLY=($(compgen -f -- "${cur}"))
            return 0
            ;;
    esac

    # Handle current word
    case "${cur}" in
        -*)
            # Complete with available options
            COMPREPLY=($(compgen -W "${all_opts}" -- "${cur}"))
            return 0
            ;;
        *)
            # Complete with PDF files by default
            COMPREPLY=($(compgen -f -X '!*.pdf' -- "${cur}"))
            
            # If no PDF files found, also suggest options
            if [[ ${#COMPREPLY[@]} -eq 0 ]]; then
                COMPREPLY=($(compgen -W "${all_opts}" -- "${cur}"))
            fi
            return 0
            ;;
    esac
}

# =============================================================================
# ZSH COMPLETION SUPPORT
# =============================================================================

# Check if running in zsh and set up zsh completion
if [[ -n "${ZSH_VERSION:-}" ]]; then
    # ZSH completion function
    _compresspdf_zsh() {
        local -a arguments
        
        arguments=(
            '(-f --file)'{-f,--file}'[Input PDF file to compress]:file:_files -g "*.pdf"'
            '(-o --output)'{-o,--output}'[Output file]:file:_files'
            '(-s --setting)'{-s,--setting}'[Compression setting]:setting:(default screen ebook printer prepress)'
            '(-l --layout)'{-l,--layout}'[Page layout]:layout:(letter a4 legal prepress)'
            '(-i --initial)'{-i,--initial}'[Initial page for range extraction]:page:'
            '(-e --end)'{-e,--end}'[End page for range extraction]:page:'
            '(-g --grayscale)'{-g,--grayscale}'[Convert to grayscale]'
            '(-c --clean)'{-c,--clean}'[Remove metadata and bookmarks]'
            '(-v --verbose)'{-v,--verbose}'[Enable verbose output]'
            '(-q --quiet)'{-q,--quiet}'[Suppress non-error output]'
            '--force[Overwrite existing output files]'
            '--dry-run[Show command without executing]'
            '--config[Use custom configuration file]:file:_files'
            '--create-config[Create default configuration file]'
            '(-h --help)'{-h,--help}'[Show help message]'
            '--version[Show version information]'
            '(-u --update)'{-u,--update}'[Update to latest version]'
            '*:input file:_files -g "*.pdf"'
        )
        
        _arguments -s -S "${arguments[@]}"
    }
    
    # Register zsh completion
    compdef _compresspdf_zsh compresspdf
    
else
    # Register bash completion
    complete -F _compresspdf_completion compresspdf
fi

# =============================================================================
# FISH SHELL COMPLETION
# =============================================================================

# Generate fish completion if fish is detected
if command -v fish >/dev/null 2>&1; then
    # Create fish completion directory if it doesn't exist
    fish_completion_dir="${HOME}/.config/fish/completions"
    
    # Function to generate fish completion file
    _generate_fish_completion() {
        local fish_completion_file="${fish_completion_dir}/compresspdf.fish"
        
        mkdir -p "${fish_completion_dir}"
        
        cat > "${fish_completion_file}" << 'EOF'
# compresspdf fish completion

# Options completion
complete -c compresspdf -s f -l file -d "Input PDF file to compress" -F
complete -c compresspdf -s o -l output -d "Output file" -F
complete -c compresspdf -s s -l setting -d "Compression setting" -x -a "default screen ebook printer prepress"
complete -c compresspdf -s l -l layout -d "Page layout" -x -a "letter a4 legal prepress"
complete -c compresspdf -s i -l initial -d "Initial page for range extraction" -x
complete -c compresspdf -s e -l end -d "End page for range extraction" -x
complete -c compresspdf -s g -l grayscale -d "Convert to grayscale"
complete -c compresspdf -s c -l clean -d "Remove metadata and bookmarks"
complete -c compresspdf -s v -l verbose -d "Enable verbose output"
complete -c compresspdf -s q -l quiet -d "Suppress non-error output"
complete -c compresspdf -l force -d "Overwrite existing output files"
complete -c compresspdf -l dry-run -d "Show command without executing"
complete -c compresspdf -l config -d "Use custom configuration file" -F
complete -c compresspdf -l create-config -d "Create default configuration file"
complete -c compresspdf -s h -l help -d "Show help message"
complete -c compresspdf -l version -d "Show version information"
complete -c compresspdf -s u -l update -d "Update to latest version"

# File completion for PDF files
complete -c compresspdf -f -a "(__fish_complete_suffix .pdf)"
EOF
        
        echo "Fish completion file created: ${fish_completion_file}"
    }
    
    # Uncomment the following line to auto-generate fish completion
    # _generate_fish_completion
fi

# =============================================================================
# INSTALLATION HELPER
# =============================================================================

# Function to install completion script
install_completion() {
    local shell_type="${1:-auto}"
    local install_type="${2:-user}"  # user or system
    
    # Auto-detect shell if not specified
    if [[ "${shell_type}" == "auto" ]]; then
        if [[ -n "${ZSH_VERSION:-}" ]]; then
            shell_type="zsh"
        elif [[ -n "${FISH_VERSION:-}" ]]; then
            shell_type="fish"
        else
            shell_type="bash"
        fi
    fi
    
    case "${shell_type}" in
        bash)
            if [[ "${install_type}" == "system" ]]; then
                local completion_dir="/etc/bash_completion.d"
                [[ ! -d "${completion_dir}" ]] && completion_dir="/usr/share/bash-completion/completions"
            else
                local completion_dir="${HOME}/.local/share/bash-completion/completions"
                mkdir -p "${completion_dir}"
            fi
            
            if [[ -d "${completion_dir}" ]]; then
                cp "${BASH_SOURCE[0]:-$0}" "${completion_dir}/compresspdf"
                echo "Bash completion installed to: ${completion_dir}/compresspdf"
                echo "Restart your shell or run: source ${completion_dir}/compresspdf"
            else
                echo "Error: Completion directory not found: ${completion_dir}"
                return 1
            fi
            ;;
        zsh)
            if [[ "${install_type}" == "system" ]]; then
                local completion_dir="/usr/share/zsh/site-functions"
            else
                local completion_dir="${HOME}/.local/share/zsh/site-functions"
                mkdir -p "${completion_dir}"
                # Add to fpath if not already there
                if [[ ":${fpath[*]}:" != *":${completion_dir}:"* ]]; then
                    echo "Add the following to your ~/.zshrc:"
                    echo "fpath=(${completion_dir} \$fpath)"
                fi
            fi
            
            if [[ -d "${completion_dir}" ]]; then
                cp "${BASH_SOURCE[0]:-$0}" "${completion_dir}/_compresspdf"
                echo "Zsh completion installed to: ${completion_dir}/_compresspdf"
                echo "Restart your shell or run: autoload -Uz compinit && compinit"
            else
                echo "Error: Completion directory not found: ${completion_dir}"
                return 1
            fi
            ;;
        fish)
            _generate_fish_completion
            ;;
        *)
            echo "Error: Unknown shell type: ${shell_type}"
            echo "Supported shells: bash, zsh, fish"
            return 1
            ;;
    esac
}

# Show help for completion script
show_completion_help() {
    cat << EOF
compresspdf completion script

USAGE:
    source compresspdf-completion.bash
    
    # Or install system-wide
    bash compresspdf-completion.bash install_completion bash system
    
    # Or install for current user
    bash compresspdf-completion.bash install_completion bash user

INSTALLATION:
    Bash (system-wide): 
        sudo cp compresspdf-completion.bash /etc/bash_completion.d/compresspdf
        
    Bash (user): 
        mkdir -p ~/.local/share/bash-completion/completions
        cp compresspdf-completion.bash ~/.local/share/bash-completion/completions/compresspdf
        
    Zsh (system-wide): 
        sudo cp compresspdf-completion.bash /usr/share/zsh/site-functions/_compresspdf
        
    Zsh (user): 
        mkdir -p ~/.local/share/zsh/site-functions
        cp compresspdf-completion.bash ~/.local/share/zsh/site-functions/_compresspdf
        # Add to ~/.zshrc: fpath=(~/.local/share/zsh/site-functions \$fpath)
        
    Fish: 
        Run this script with fish shell to auto-generate completion

FEATURES:
    - Completes PDF files for input
    - Completes all files for output
    - Completes valid settings and layouts
    - Works with both short and long options
    - Supports bash, zsh, and fish shells

EOF
}

# =============================================================================
# SCRIPT ENTRY POINT
# =============================================================================

# If script is run directly (not sourced), show help or run install function
if [[ "${BASH_SOURCE[0]:-$0}" == "${0}" ]]; then
    case "${1:-}" in
        install_completion)
            install_completion "${2:-}" "${3:-}"
            ;;
        help|--help|-h)
            show_completion_help
            ;;
        *)
            show_completion_help
            ;;
    esac
fi