#!/bin/bash

# Quick Action: Compress PDF (Quick - Default settings)
# Compresses PDFs with clean metadata and letter size
# No dialogs, fast compression

# Set PATH to include common installation locations
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Check if compresspdf is installed
if ! command -v compresspdf &> /dev/null; then
    osascript -e 'display dialog "compresspdf no está instalado.\n\nInstálalo con:\ncurl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh | bash" buttons {"OK"} default button "OK" with icon stop'
    exit 1
fi

# Process each selected file
for file in "$@"; do
    # Check if file is a PDF
    if [[ "${file}" =~ \.pdf$ ]]; then
        # Get the directory and filename
        dir=$(dirname "${file}")
        filename=$(basename "${file}" .pdf)
        output="${dir}/${filename}_small.pdf"
        
        # Show notification
        osascript -e "display notification \"Comprimiendo: ${filename}.pdf\" with title \"Compress PDF\" subtitle \"Clean + Letter\""
        
        # Run compresspdf with default settings (screen quality, clean metadata, letter)
        if compresspdf -f "${file}" -o "${output}" -c -l letter 2>&1 && [ -f "${output}" ]; then
            # Get file sizes for notification
            original_size=$(du -h "${file}" | cut -f1)
            compressed_size=$(du -h "${output}" | cut -f1)
            
            osascript -e "display notification \"✓ ${original_size} → ${compressed_size}\" with title \"Compress PDF\" subtitle \"${filename}_small.pdf\" sound name \"Glass\""
        else
            osascript -e "display notification \"✗ Error al comprimir\" with title \"Compress PDF\" subtitle \"${filename}.pdf\" sound name \"Basso\""
        fi
    else
        osascript -e 'display notification "El archivo no es un PDF" with title \"Compress PDF\" sound name \"Basso\"'
    fi
done
