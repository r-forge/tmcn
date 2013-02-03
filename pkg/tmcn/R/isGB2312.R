
##' Indicate whether the encoding of input string is GB2312.
##' 
##' @title Indicate whether the encoding of input string is GB2312.
##' @param string A character vector.
##' @return Logical value.
##' @author Jian Li <\email{rweibo@@sina.com}>

isGB2312 <- function(string)
{
	
	string <- .verifyChar(string)
	if (length(string)  == 1) {
		OUT <- .C("CWrapper_encoding_isgb2312", 
				characters = as.character(string),  
				numres = 2L)
		OUT <- as.logical(OUT$numres)
	} else {
		OUT <- as.vector(sapply(string, isUTF8))
	}
	return(OUT)
}

