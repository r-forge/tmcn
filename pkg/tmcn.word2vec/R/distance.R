
##' Calculate the distance of the word.
##' 
##' @title Calculate the distance of the word.
##' @param file_name Path of the modle file.
##' @param word The search word.
##' @return A list with the input.
##' @author Jian Li <\email{rweibo@@sina.com}>

distance <- function(file_name, word)
{
	if (!file.exists(file_name)) stop("Can't find the model file!")
	N <- 20
	
	OUT <- .C("CWrapper_distance", 
			file_name = as.character(file_name), 
			word = as.character(word),
			returnw = "",
			returnd = as.double(rep(0,N)))
	#return(OUT)
	vword <- strsplit(gsub("^ *", "", OUT$returnw), split = " ")[[1]]
	vdist <- OUT$returnd
	if (length(vword) == 0) vdist <- numeric()
	return(data.frame(Word = vword, CosDist = vdist, stringsAsFactors = FALSE))
}

