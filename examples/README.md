# Examples

This directory contains example files and sample data for testing `compresspdf`.

## Sample Files

- `sample.pdf` - Small sample PDF for testing (to be added)
- `config-example` - Example configuration file

## Usage Examples

### Basic compression:
```bash
compresspdf examples/sample.pdf
```

### High quality compression:
```bash
compresspdf -s printer examples/sample.pdf
```

### With custom output and options:
```bash
compresspdf -s ebook -l a4 -g -o compressed.pdf examples/sample.pdf
```

## Creating Test Files

You can create your own test PDF files or download sample PDFs from:
- https://www.pdf995.com/samples (sample documents)
- http://www.africau.edu/images/default/sample.pdf (simple test file)

To download a test file:
```bash
curl -o examples/sample.pdf http://www.africau.edu/images/default/sample.pdf
```