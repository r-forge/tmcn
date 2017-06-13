
##' Create a word frequency data.frame.
##' 
##' @title Create a word frequency data.frame.
##' @param obj A character vector or \code{DocumentTermMatrix} to calculate words frequency.
##' @param onlyCN Keep only chinese words. 
##' @param stopwords A character vector of stop words.
##' @param useStopDic Whether to use the default stop words.
##' @return A data.frame.
##' @author Jian Li <\email{rweibo@@sina.com}>
##' @examples
##' createWordFreq(c("a", "a", "b", "c"), onlyCN = FALSE, useStopDic = FALSE)
##' 

createWordFreq <- function(obj, onlyCN = TRUE, stopwords = NULL, useStopDic = TRUE)
{
	if (inherits(obj, "DocumentTermMatrix")) {
		t0 <- apply(obj, 2, sum)
	} else if (inherits(obj, "TermDocumentMatrix")) {
		t0 <- apply(obj, 1, sum)
	} else {
		obj <- .verifyChar(obj)
		if (length(obj) == 0) {
			return(data.frame(word = character(), freq = integer(), stringsAsFactors = FALSE))
		}
		t0 <- table(obj)
	}
	
	OUT <- data.frame(word = names(t0), freq = as.vector(t0), stringsAsFactors = FALSE)
	OUT <- OUT[order(OUT$freq, decreasing = TRUE), ]
		
	if (onlyCN) {
		OUT <- OUT[!grepl("[^\u4e00-\u9fa5]", OUT$word), ]
	} else {
		OUT <- OUT[!grepl("[^\u4e00-\u9fa5A-Za-z]", OUT$word), ]
	}
	
	if (identical(useStopDic, TRUE)) {
		stopwords <- .verifyChar(stopwords)
		.tmcnEnv <- get(".tmcnEnv", envir = .GlobalEnv)
		utils::data(STOPWORDS, envir = .tmcnEnv)
		STOPWORDS <- get("STOPWORDS", envir = .tmcnEnv)
		stopwords <- union(stopwords, STOPWORDS$word)
		OUT <- OUT[!OUT$word %in% stopwords, ]
	} 

	return(OUT)
}

