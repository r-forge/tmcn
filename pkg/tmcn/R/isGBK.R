
##' Indicate whether the encoding of input string is GBK.
##' 
##' @title Indicate whether the encoding of input string is GBK.
##' @param string A character vector.
##' @return Logical value.
##' @author Jian Li <\email{rweibo@@sina.com}>

isGBK <- function(string)
{
	
	string <- .verifyChar(string)
	if (length(string)  == 1) {
		OUT <- .C("CWrapper_encoding_isgbk", 
				characters = as.character(string),  
				numres = 2L)
		OUT <- as.logical(OUT$numres)
	} else {
		OUT <- as.vector(sapply(string, isUTF8))
	}
	return(OUT)
}

