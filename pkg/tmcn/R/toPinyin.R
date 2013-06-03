
##' Convert a chinese text to pinyin format.
##' 
##' @title Convert a chinese text to pinyin format.
##' @param string A character vector.
##' @param capitalize Whether to capitalize the first letter of each word. 
##' @return A character vector in pinyin format.
##' @author Jian Li <\email{rweibo@@sina.com}>
##' @keywords string
##' @examples \dontrun{
##' toPinyin("the quick red fox jumps over the lazy brown dog")
##' }
##'

toPinyin <- function(string, capitalize = FALSE) {
	string <- .verifyChar(string)
	data(Dataset.GBK, envir = parent.frame())
	if (capitalize) Dataset.GBK$py0 <- strcap(Dataset.GBK$py0) 
	e.hash <- createHashmapEnv(Dataset.GBK$GBK, Dataset.GBK$py0)
	OUT <- strsplit(string, split = "")
	OUT <- lapply(OUT, FUN = function(X) 
				sapply(X, FUN = function(Y) 
						{res <- Y; try(res <- as.character(get(Y, envir = e.hash)), silent = TRUE); res}
				)
	)
	OUT <- sapply(OUT, FUN = function(X) paste(X, collapse = ""))
	return(OUT)
}

