
##' Convert encoding for right displaying in Chinese.
##' 
##' @title Convert encoding for right displaying in Chinese.
##' @param string A character vector.
##' @return Converted vectors.
##' @author Jian Li <\email{rweibo@@sina.com}>

toCN <- function(string)
{

	string <- .verifyChar(string)
	sysenc <- getCharset()
	cncharset <- c("BIG-5", "BIG-FIVE", "big5", "BIG5", "big5-hkscs", "BIG5-HKSCS", 
			"big5hkscs", "BIG5HKSCS", "CP936", "GB18030", "gb2312", "GBK", "hz-gb-2312", 
			"x-mac-chinesesimp", "x-mac-chinesetrad", "x_Chinese-Eten")
	if (sysenc %in% cncharset) {
		if(any(isUTF8(string))) {
			OUT <- iconv(string, "UTF-8", "GBK")
		} else {
			OUT <- iconv(string, "GBK", "GBK")
		}
	} else {
		OUT <- toUTF8(string)
	}
	
	return(OUT)
}

