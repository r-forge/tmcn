
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
##' @param binary Whether to output binary, default is 1 means binary.
##' @return A list with the input.
##' @author Jian Li <\email{rweibo@@sina.com}>

word2vec <- function(train_file, output_file, binary = 1)
{
	if (!file.exists(train_file)) stop("Can't find the trsin file!")
	if (!file.exists(dirname(output_file))) dir.create(dirname(output_file), recursive = TRUE)
	
	OUT <- .C("CWrapper_word2vec", 
			train_file = as.character(train_file), 
			output_file = as.character(output_file),
			binary = as.character(binary))
	cat(paste("The model was generated in '", dirname(output_file), "'!\n", sep = ""))
	return(OUT)
}

