import sys, re, os, optparse

VALIDATION_ERROR_CODE = 1
OUTPUT_FILE_NAME = "formatted_gene_list.txt"
MAX_ALLOWED_GENES = 1000000
MAX_ID_LENGTH = 80
VALID_DELIM = r"[\s,;]"
VALID_GENE_ID = r"[a-zA-Z0-9\(\)\.\:_-]*$"

class ValidationException(BaseException):
    """
    A validation error.
    """
    pass

def execute():
    try:
        inputDir, outputDir = collectAndValidateCliArgs()
        
        origFile = inputDir + "/" + os.listdir(inputDir)[0]
        formattedFile = outputDir + "/" + OUTPUT_FILE_NAME

        create_formatted_genelist_file(origFile, formattedFile)
        validate_genelist(formattedFile)         

    except ValidationException as e:
        print(e, file=sys.stdout) # validation error must go to STDOUT, to ship to user
        sys.exit(VALIDATION_ERROR_CODE)
          
        
def collectAndValidateCliArgs():
    (options, args) = optparse.OptionParser().parse_args()
    if len(args) < 2:
        usage()
        
    inputDir = args[0]
    outputDir = args[1]

    if not (os.path.isdir(inputDir) and len(os.listdir(inputDir)) == 1):
        raise Exception("input_dir must exist and contain exactly one file.")

    if not (os.path.isdir(outputDir) and len(os.listdir(outputDir)) == 0):
        raise Exception("output_dir must exist and be empty.")

    return inputDir, outputDir

        
def create_formatted_genelist_file(origGeneListFile, outputFormattedFile):
    """
        Formats the input gene list file, transforming all commas, spaces and tabs to new lines. This enables
        compatibility with dataset lists of genes uploaded as dataset parameters in WDK. The downstream installer
        inserts a gene ID into the database for each line in the file passed to it.
        """
    formatted_file = open(outputFormattedFile, 'w')
    first = True
    genes_set = {"initialize_this_set_with_something"}
    genes_count = 0
    with open(origGeneListFile, 'r') as source_file:
        for line in source_file:
            gene_id = line.strip()
            if gene_id != "" and gene_id not in genes_set:
                if not first:
                    formatted_file.write("\n")
                first=False
                formatted_file.write(re.sub(VALID_DELIM, "\n", gene_id))
                genes_set.add(gene_id)
                genes_count += 1
                if genes_count > MAX_ALLOWED_GENES:
                    raise ValidationException("Invalid number of genes.  Maximum allowed is 1,000,000")
                    
    if genes_count == 0:
        raise ValidationException("No genes found.  Empty file.")
    formatted_file.close()

def validate_genelist(formattedGeneListFile):

    with open(formattedGeneListFile, 'r') as formatted_file:
        for line in formatted_file:
            gene_id = line.strip()
            if len(gene_id) == 0:
                continue  
            if not re.match(VALID_GENE_ID, gene_id):
                raise ValidationException("Invalid character found in Gene identifier: " + gene_id + ". Does not conform to pattern: " + VALID_GENE_ID)
            if len(gene_id) > MAX_ID_LENGTH:
                raise ValidationException("Gene identifier: " + gene_id + " exceeds maximum length of " + str(MAX_ID_LENGTH))

def usage():
    usage = """
Usage: {} input_dir output_dir

Prepare and validate a gene list dataset for import.

input_dir: must contain the original dataset files, and no other files. In this case, exactly one file, a gene list.
output_dir: will contain the import-ready set of files.  In this case, a file with name 'formatted_gene_list.txt'

If there is a validation error, exit with status {}.  STDOUT will contain the user-appropriate validation error message""".format(sys.argv[0], VALIDATION_ERROR_CODE)
    
    print(usage, file=sys.stderr)
    exit(-1)
