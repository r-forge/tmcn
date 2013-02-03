
##' Indicate whether the encoding of input string is UTF-8.
##' 
##' @title Indicate whether the encoding of input string is UTF-8.
##' @param string A character vector.
##' @return Logical value.
##' @author Jian Li <\email{rweibo@@sina.com}>

isUTF8 <- function(string)
{
	
	string <- .verifyChar(string)
	if (length(string)  == 1) {
		OUT <- .C("CWrapper_encoding_isutf8", 
				characters = as.character(string),  
				numres = 2L)
		OUT <- as.logical(OUT$numres)
	} else {
		OUT <- as.vector(sapply(string, isUTF8))
	}
	return(OUT)
}

