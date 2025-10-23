#!/bin/bash

# Quick Action: Compress PDF (Custom settings)
# Allows choosing quality, layout, and options

# Set PATH to include common installation locations
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Check if compresspdf is installed
if ! command -v compresspdf &> /dev/null; then
    osascript -e 'display dialog "compresspdf no está instalado.\n\nInstálalo con:\ncurl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh | bash" buttons {"OK"} default button "OK" with icon stop'
    exit 1
fi

# Ask for quality
quality=$(osascript -e 'choose from list {"screen (baja calidad, menor tamaño)", "ebook (calidad media)", "printer (alta calidad)", "prepress (máxima calidad)"} with prompt "Selecciona la calidad de compresión:" default items {"ebook (calidad media)"}')

# Check if user cancelled
if [ "$quality" = "false" ]; then
    exit 0
fi

# Extract quality value
case "$quality" in
    "screen"*) quality_flag="screen" ;;
    "ebook"*) quality_flag="ebook" ;;
    "printer"*) quality_flag="printer" ;;
    "prepress"*) quality_flag="prepress" ;;
esac

# Ask for options
options=$(osascript -e 'choose from list {"Limpiar metadata (-c)", "Formato Letter (-l)", "Ambas opciones"} with prompt "Opciones adicionales:" default items {"Ambas opciones"}')

# Check if user cancelled
if [ "$options" = "false" ]; then
    exit 0
fi

# Build command arguments array
cmd_args=(-q "${quality_flag}")
case "$options" in
    "Limpiar metadata"*) cmd_args+=(-c) ;;
    "Formato Letter"*) cmd_args+=(-l letter) ;;
    "Ambas opciones"*) cmd_args+=(-c -l letter) ;;
esac

# Process each selected file
for file in "$@"; do
    # Check if file is a PDF
    if [[ "${file}" =~ \.pdf$ ]]; then
        # Get the directory and filename
        dir=$(dirname "${file}")
        filename=$(basename "${file}" .pdf)
        output="${dir}/${filename}_compressed.pdf"
        
        # Show notification
        osascript -e "display notification \"Comprimiendo: ${filename}.pdf\" with title \"Compress PDF\" subtitle \"${quality_flag}\""
        
        # Run compresspdf with custom settings (options must go before -f)
        if compresspdf "${cmd_args[@]}" -f "${file}" -o "${output}" 2>&1 && [ -f "${output}" ]; then
            # Get file sizes for notification
            original_size=$(du -h "${file}" | cut -f1)
            compressed_size=$(du -h "${output}" | cut -f1)
            
            osascript -e "display notification \"✓ ${original_size} → ${compressed_size}\" with title \"Compress PDF\" subtitle \"${filename}_compressed.pdf\" sound name \"Glass\""
        else
            osascript -e "display notification \"✗ Error al comprimir\" with title \"Compress PDF\" subtitle \"${filename}.pdf\" sound name \"Basso\""
        fi
    else
        osascript -e 'display notification "El archivo no es un PDF" with title "Compress PDF" sound name "Basso"'
    fi
done
