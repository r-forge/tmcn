
##' Train a model by word2vec.
##' 
##' The word2vec tool takes a text corpus as input and produces the 
##' word vectors as output. It first constructs a vocabulary from the 
##' training text data and then learns vector representation of words. 
##' The resulting word vector file can be used as features in many 
##' natural language processing and machine learning applications.
##'
##' @title Train a model by word2vec.
##' @param train_file Path of the train file.
##' @param output_file Path of the output file.
##' @return A word2vec object.
##' @author Jian Li <\email{rweibo@@sina.com}>
##' @references \url{https://code.google.com/p/word2vec/}
##' @examples \dontrun{
##' word2vec(system.file("examples", "rfaq.txt", package = "tmcn.word2vec"))
##' }

word2vec <- function(train_file, output_file)
{
	if (!file.exists(train_file)) stop("Can't find the trsin file!")
	train_dir <- dirname(train_file)
	
	if(missing(output_file)) {
		output_file <- gsub(gsub("^.*\\.", "", basename(train_file)), "bin", basename(train_file))
		output_file <- file.path(train_dir, output_file)
	}
	
	outfile_dir <- dirname(output_file)
	if (!file.exists(outfile_dir)) dir.create(outfile_dir, recursive = TRUE)
	
	train_file <- normalizePath(train_file, winslash = "/", mustWork = FALSE)
	output_file <- normalizePath(output_file, winslash = "/", mustWork = FALSE)
	# Whether to output binary, default is 1 means binary.
	binary = 1
	
	OUT <- .C("CWrapper_word2vec", 
			train_file = as.character(train_file), 
			output_file = as.character(output_file),
			binary = as.character(binary))
	
	class(OUT) <- "word2vec"
	names(OUT)[2] <- "model_file"
	cat(paste("The model was generated in '", dirname(output_file), "'!\n", sep = ""))
	return(OUT)
}

