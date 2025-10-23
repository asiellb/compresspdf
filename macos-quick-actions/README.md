# macOS Quick Actions

Este directorio contiene los Quick Actions (Acciones Rápidas) de macOS para comprimir PDFs desde Finder.

## Quick Actions Disponibles

### 1. Compress PDF (Quick)
Compresión rápida con configuración predeterminada. No muestra diálogos, ideal para comprimir rápidamente.

**Configuración:**
- Calidad: Screen (baja calidad, menor tamaño)
- Limpia metadata automáticamente
- Formato Letter
- Salida: `nombrearchivo_small.pdf`

**Uso:**
1. Haz clic derecho en un archivo PDF en Finder
2. Selecciona **Quick Actions → Compress PDF (Quick)**
3. El archivo comprimido aparecerá en la misma carpeta

### 2. Compress PDF (Custom)
Compresión interactiva que permite elegir opciones.

**Opciones:**
- **Calidad:** screen, ebook, printer, o prepress
- **Opciones adicionales:**
  - Limpiar metadata
  - Formato Letter
  - Ambas opciones

**Salida:** `nombrearchivo_compressed.pdf`

**Uso:**
1. Haz clic derecho en un archivo PDF en Finder
2. Selecciona **Quick Actions → Compress PDF (Custom)**
3. Elige la calidad deseada
4. Elige las opciones adicionales
5. El archivo comprimido aparecerá en la misma carpeta

## Instalación

Los Quick Actions se instalan automáticamente al ejecutar:

```bash
curl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh | bash -s install
```

## Instalación Manual

Si prefieres instalar manualmente:

```bash
# Copiar los workflows
cp -R "Compress PDF (Quick).workflow" ~/Library/Services/
cp -R "Compress PDF (Custom).workflow" ~/Library/Services/

# Dar permisos
chmod -R 755 ~/Library/Services/"Compress PDF (Quick).workflow"
chmod -R 755 ~/Library/Services/"Compress PDF (Custom).workflow"

# Refrescar la base de datos de Services
/System/Library/CoreServices/pbs -flush
/System/Library/CoreServices/pbs -update
killall -HUP Finder
```

## Estructura de los Workflows

Cada workflow es un bundle de macOS con la siguiente estructura:

```
Compress PDF (Quick).workflow/
├── Contents/
    ├── Info.plist          # Configuración del Service/Quick Action
    └── document.wflow      # Workflow de Automator con el script
```

### Info.plist

Contiene la configuración del Service:
- `NSServices`: Define el nombre del menú y los tipos de archivo aceptados
- `NSSendFileTypes`: Especifica que solo acepta PDFs (`com.adobe.pdf`, `public.pdf`)

### document.wflow

Archivo plist XML que contiene:
- Metadata del workflow (versión de Automator, etc.)
- Array de acciones (en este caso, "Run Shell Script")
- El script bash que ejecuta la compresión

## Notificaciones

Los workflows muestran notificaciones de macOS durante el proceso:

- **Inicio:** "Comprimiendo: archivo.pdf"
- **Éxito:** "✓ tamaño_original → tamaño_comprimido"
- **Error:** "✗ Error al comprimir"

## Requisitos

- macOS (cualquier versión con soporte de Services/Quick Actions)
- `compresspdf` instalado
- Ghostscript instalado

## Notas

- Si los Quick Actions no aparecen inmediatamente después de la instalación, cierra sesión y vuelve a iniciarla
- Los workflows funcionan con múltiples archivos seleccionados (procesa cada uno)
- Los nombres de archivo con espacios son soportados correctamente
- Los workflows crean nuevos archivos, nunca sobrescriben los originales

## Solución de Problemas

### Los Quick Actions no aparecen en Finder

1. Verifica que los workflows estén instalados:
   ```bash
   ls -la ~/Library/Services/ | grep -i compress
   ```

2. Refresca la base de datos de Services:
   ```bash
   /System/Library/CoreServices/pbs -flush
   /System/Library/CoreServices/pbs -update
   killall -HUP Finder
   ```

3. Cierra sesión y vuelve a iniciarla

### Error: "compresspdf no está instalado"

Instala `compresspdf`:
```bash
curl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh | bash -s install
```

### Los workflows aparecen como "dañados o incompletos"

Esto puede ocurrir si los workflows no tienen la estructura correcta. Reinstala:
```bash
curl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh | bash -s install --force
```

## Desarrollo

Para modificar los workflows:

1. Abre el workflow en Automator:
   ```bash
   open -a Automator ~/Library/Services/"Compress PDF (Quick).workflow"
   ```

2. Modifica el script de shell en la acción "Run Shell Script"

3. Guarda los cambios

4. Copia el workflow modificado de vuelta al repositorio:
   ```bash
   cp -R ~/Library/Services/"Compress PDF (Quick).workflow" /path/to/repo/macos-quick-actions/
   ```

## Referencias

- [Automator User Guide](https://support.apple.com/guide/automator/welcome/mac)
- [macOS Services Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/SysServices/introduction.html)
