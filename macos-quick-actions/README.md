# macOS Quick Actions para compresspdf

Este directorio contiene Quick Actions (Acciones Rápidas) para macOS que te permiten comprimir PDFs directamente desde el Finder.

## Quick Actions disponibles

### 1. Compress PDF (Quick)
**Archivo:** `compress-pdf-quick.sh`

Compresión rápida con configuración predeterminada:
- Limpia metadatos
- Tamaño: Letter
- Calidad: Screen (72 dpi)
- Sin diálogos interactivos

Perfecto para uso rápido diario.

### 2. Compress PDF (Custom)
**Archivo:** `compress-pdf-custom.sh`

Compresión interactiva con opciones personalizables:
- Selección de calidad (Pantalla, eBook, Impresión)
- Selección de tamaño (Letter, A4, Legal)
- Opción de convertir a escala de grises
- Opción de limpiar metadatos
- Muestra resumen al finalizar

Perfecto cuando necesitas control sobre la compresión.

## Instalación automática

Los Quick Actions se instalan automáticamente cuando ejecutas:

```bash
bash scripts/install.sh
```

O durante la instalación desde GitHub:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh)
```

## Instalación manual

Si prefieres instalar manualmente los Quick Actions:

1. Abre **Automator** (Cmd + Espacio, luego escribe "Automator")
2. Selecciona **Quick Action** (Acción Rápida)
3. En la parte superior, configura:
   - Workflow receives: **files or folders** (archivos o carpetas)
   - in: **Finder.app**
   - Image: (opcional) Puedes seleccionar un ícono
   - Color: (opcional) Puedes seleccionar un color
4. Busca la acción **Run Shell Script** (Ejecutar script de shell) y arrástrala al área de trabajo
5. Configura:
   - Shell: **/bin/bash**
   - Pass input: **as arguments** (como argumentos)
6. Copia el contenido del script correspondiente (`compress-pdf-quick.sh` o `compress-pdf-custom.sh`)
7. Pégalo en el área de texto del script
8. Guarda con Cmd+S y dale un nombre descriptivo:
   - "Compress PDF (Quick)" para la versión rápida
   - "Compress PDF (Custom)" para la versión interactiva

## Uso

Una vez instalados, puedes usar los Quick Actions de dos formas:

### Desde el Finder:
1. Selecciona uno o más archivos PDF
2. Click derecho → **Quick Actions** → **Compress PDF (Quick)** o **Compress PDF (Custom)**

### Desde la barra táctil (Touch Bar):
Los Quick Actions también aparecerán en la Touch Bar cuando selecciones archivos PDF.

## Ubicación de archivos comprimidos

Los archivos comprimidos se guardan en el mismo directorio que el archivo original con el sufijo:
- `_small.pdf` para Quick
- `_compressed.pdf` para Custom

## Notificaciones

Ambos Quick Actions muestran notificaciones de macOS para informarte del progreso y resultado:
- Inicio de compresión
- Finalización exitosa con tamaños de archivo
- Errores si los hay

## Desinstalación

Para desinstalar los Quick Actions:

1. Abre Finder
2. Ve a `~/Library/Services/`
3. Elimina los archivos `.workflow` correspondientes

O usa el comando:

```bash
rm ~/Library/Services/Compress\ PDF\ \(Quick\).workflow
rm ~/Library/Services/Compress\ PDF\ \(Custom\).workflow
```

## Requisitos

- macOS 10.10 o superior
- `compresspdf` instalado y en el PATH
- Permisos de escritura en el directorio de los PDFs

## Solución de problemas

### "compresspdf no está instalado"
Instala compresspdf primero:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/asiellb/compresspdf/master/scripts/install.sh)
```

### Los Quick Actions no aparecen en el menú
1. Verifica que estén en `~/Library/Services/`
2. Reinicia el Finder: Opción+Click derecho en el ícono del Finder → Reabrir
3. O cierra sesión y vuelve a iniciar

### "Operación no permitida"
Da permisos a Automator para acceder a archivos:
1. Preferencias del Sistema → Seguridad y Privacidad
2. Privacidad → Acceso Total al Disco
3. Agrega Automator y Terminal

## Personalización

Puedes editar los scripts para cambiar el comportamiento predeterminado:

- En Quick: Cambia los parámetros de `compresspdf` en la línea del comando
- En Custom: Modifica los botones y opciones en los diálogos de AppleScript
