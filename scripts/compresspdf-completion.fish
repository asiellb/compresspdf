# compresspdf fish completion

# Helper function to list only PDF files
function __compresspdf_pdfs
    # Use commandline to get proper file completions for PDF files only
    for file in *.pdf **/*.pdf
        test -f "$file"; and echo $file
    end 2>/dev/null
end

# Options with PDF file completion
complete -c compresspdf -s f -l file -d "Input PDF file to compress" -x -a "(__compresspdf_pdfs)"
complete -c compresspdf -s o -l output -d "Output file" -r -F

# Options with predefined values
complete -c compresspdf -s s -l setting -d "Compression setting" -x -a "default screen ebook printer prepress"
complete -c compresspdf -s l -l layout -d "Page layout" -x -a "letter a4 legal prepress"

# Options with numeric values
complete -c compresspdf -s i -l initial -d "Initial page for range extraction" -x
complete -c compresspdf -s e -l end -d "End page for range extraction" -x

# Boolean flags
complete -c compresspdf -s g -l grayscale -d "Convert to grayscale"
complete -c compresspdf -s c -l clean -d "Remove metadata and bookmarks"
complete -c compresspdf -s v -l verbose -d "Enable verbose output"
complete -c compresspdf -s q -l quiet -d "Suppress non-error output"

# Other options
complete -c compresspdf -l force -d "Overwrite existing output files"
complete -c compresspdf -l dry-run -d "Show command without executing"
complete -c compresspdf -l config -d "Use custom configuration file" -r -F
complete -c compresspdf -l create-config -d "Create default configuration file"

# Help and version options
complete -c compresspdf -s h -l help -d "Show help message"
complete -c compresspdf -l version -d "Show version information"
complete -c compresspdf -s u -l update -d "Update to latest version"

# Default argument completion: PDF files
complete -c compresspdf -f -a "(__compresspdf_pdfs)"
