#!/bin/bash

# Quick Action: Compress PDF (Custom - Interactive)
# Interactive compression with options for quality, layout, grayscale, etc.

# Check if compresspdf is installed
if ! command -v compresspdf &> /dev/null; then
    osascript -e 'display dialog "compresspdf no está instalado.\n\nInstálalo con:\nbash <(curl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh)" buttons {"OK"} default button "OK" with icon stop'
    exit 1
fi

# Process each selected file
for file in "$@"; do
    # Check if file is a PDF
    if [[ ! "${file}" =~ \.pdf$ ]]; then
        osascript -e 'display notification "El archivo no es un PDF" with title "Compress PDF" sound name "Basso"'
        continue
    fi
    
    # Get filename for display
    filename=$(basename "${file}")
    
    # Show interactive dialog for compression settings
    settings=$(osascript << EOF
set theFile to "${filename}"

-- Dialog for quality settings
set qualityDialog to display dialog "Configuración de compresión para:" & return & return & theFile & return & return & "Selecciona la calidad:" buttons {"Cancelar", "Pantalla (72dpi)", "eBook (150dpi)", "Impresión (300dpi)"} default button "eBook (150dpi)" with title "Compress PDF - Calidad"
set qualityChoice to button returned of qualityDialog

if qualityChoice is "Cancelar" then
    return "CANCEL"
end if

-- Map quality choice to setting
if qualityChoice is "Pantalla (72dpi)" then
    set qualitySetting to "screen"
else if qualityChoice is "eBook (150dpi)" then
    set qualitySetting to "ebook"
else if qualityChoice is "Impresión (300dpi)" then
    set qualitySetting to "printer"
end if

-- Dialog for page layout
set layoutDialog to display dialog "Selecciona el tamaño de página:" buttons {"Cancelar", "Letter", "A4", "Legal"} default button "Letter" with title "Compress PDF - Tamaño"
set layoutChoice to button returned of layoutDialog

if layoutChoice is "Cancelar" then
    return "CANCEL"
end if

-- Map layout choice to setting (lowercase)
if layoutChoice is "Letter" then
    set layoutSetting to "letter"
else if layoutChoice is "A4" then
    set layoutSetting to "a4"
else if layoutChoice is "Legal" then
    set layoutSetting to "legal"
end if

-- Dialog for additional options
set optionsDialog to display dialog "Opciones adicionales:" buttons {"Continuar"} default button "Continuar" with title "Compress PDF - Opciones"
set cleanMetadata to true
set grayscale to false

-- Ask about grayscale
set grayscaleDialog to display dialog "¿Convertir a escala de grises?" buttons {"No", "Sí"} default button "No" with title "Compress PDF - Escala de grises"
if button returned of grayscaleDialog is "Sí" then
    set grayscale to true
end if

-- Ask about metadata cleaning
set metadataDialog to display dialog "¿Eliminar metadatos?" buttons {"No", "Sí"} default button "Sí" with title "Compress PDF - Metadatos"
if button returned of metadataDialog is "Sí" then
    set cleanMetadata to true
else
    set cleanMetadata to false
end if

-- Return settings as comma-separated string
set result to qualitySetting & "," & layoutSetting & ","
if cleanMetadata then
    set result to result & "clean,"
else
    set result to result & "noClean,"
end if
if grayscale then
    set result to result & "grayscale"
else
    set result to result & "color"
end if

return result
EOF
)
    
    # Check if user cancelled
    if [[ "${settings}" == "CANCEL" ]]; then
        continue
    fi
    
    # Parse settings
    IFS=',' read -r quality layout clean_opt grayscale_opt <<< "${settings}"
    
    # Build compresspdf command
    dir=$(dirname "${file}")
    filename_base=$(basename "${file}" .pdf)
    output="${dir}/${filename_base}_compressed.pdf"
    
    # Build command arguments
    cmd_args=("-f" "${file}" "-o" "${output}" "-s" "${quality}" "-l" "${layout}")
    
    # Add optional flags
    if [[ "${clean_opt}" == "clean" ]]; then
        cmd_args+=("-c")
    fi
    
    if [[ "${grayscale_opt}" == "grayscale" ]]; then
        cmd_args+=("-g")
    fi
    
    # Show notification
    osascript -e "display notification \"Comprimiendo con ${quality} + ${layout}...\" with title \"Compress PDF\" subtitle \"${filename}\""
    
    # Run compresspdf
    if compresspdf "${cmd_args[@]}" 2>&1 | grep -q "successfully"; then
        # Get file sizes for notification
        original_size=$(du -h "${file}" | cut -f1)
        compressed_size=$(du -h "${output}" | cut -f1)
        
        # Show success notification with summary
        osascript -e "display notification \"✓ ${original_size} → ${compressed_size}\" with title \"Compress PDF\" subtitle \"${filename_base}_compressed.pdf\" sound name \"Glass\""
        
        # Show summary dialog
        osascript << EOF
display dialog "Compresión completada exitosamente" & return & return & \
    "Archivo original: ${original_size}" & return & \
    "Archivo comprimido: ${compressed_size}" & return & return & \
    "Configuración:" & return & \
    "  • Calidad: ${quality}" & return & \
    "  • Tamaño: ${layout}" & return & \
    "  • Limpiar metadatos: ${clean_opt}" & return & \
    "  • Escala de grises: ${grayscale_opt}" \
    buttons {"OK"} default button "OK" with title "Compress PDF - Completado" with icon note
EOF
    else
        osascript -e "display notification \"✗ Error al comprimir\" with title \"Compress PDF\" subtitle \"${filename}\" sound name \"Basso\""
        osascript -e 'display dialog "Error al comprimir el archivo.\n\nRevisa que el PDF no esté corrupto y que tengas permisos de escritura." buttons {"OK"} default button "OK" with icon stop with title "Compress PDF - Error"'
    fi
done
