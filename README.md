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
compresspdf [[ -f [file] -s [ebook|printer|prepress] ] | [ -h ]]
```
