
##' Convert encoding to UTF-8.
##' 
##' @title Convert encoding to UTF-8.
##' @param string A character vector.
##' @return Converted vectors.
##' @author Jian Li <\email{rweibo@@sina.com}>

toUTF8 <- function(string)
{

	string <- .verifyChar(string)
	if(any(isUTF8(string))) {
		OUT <- string
		Encoding(OUT) <- "UTF-8"
	} else {
		strenc <- Encoding(string)[which(Encoding(string) != "unknown")][1]
		if (is.na(strenc)) strenc <- "GBK"
		OUT <- iconv(string, strenc, "UTF-8")
	}
	
	return(OUT)
}

