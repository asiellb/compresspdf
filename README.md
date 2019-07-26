# CompressPDF
Shell script to compress pdf using `Ghostscript` lib.

## Description
Shell script to compress pdf using `Ghostscript`:
 - Reduce BigPDF Files
 - Optimize the PDF size

## Requierement

### MacOS
```
brew install ghostscript
```
### Linux
```
yum install ghostscript
```
### Windows
Go to [download link](https://www.ghostscript.com/download/gsdnld.html), select your platform and install it!.

### Compile it from source

Please refer to the offical [documentation](https://www.ghostscript.com/documentation.html), select the version what you looking for and HOWTO compile `Ghostscript`.

## Installation
```
sudo wget https://raw.githubusercontent.com/asiellb/compresspdf/master/compresspdf -O /usr/local/bin/compresspdf && sudo chmod +x /usr/local/bin/compresspdf
```
## Usage

```
compresspdf [ [ -f [file] -s [escreen|ebook|printer|prepress] -i [initial page] -e [end page] -g ] | -h ]
```

Settings options:

- /screen selects low-resolution (72 dpi images) output similar to the Acrobat Distiller "Screen Optimized" setting.
- /ebook selects medium-resolution (150 dpi images) output similar to the Acrobat Distiller "eBook" setting.
- /printer selects output (300 dpi images) similar to the Acrobat Distiller "Print Optimized" setting.
- /prepress selects output (300 dpi images, color preserving) similar to Acrobat Distiller "Prepress Optimized" setting.
- /default selects output intended to be useful across a wide variety of uses, possibly at the expense of a larger output file.
