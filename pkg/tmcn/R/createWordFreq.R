
##' Create a word frequency data.frame.
##' 
##' @title Create a word frequency data.frame.
##' @param string A character vector to calculate words frequency.
##' @param onlyCN Keep only chinese words. 
##' @param stopwords A character vector of stop words.
##' @param useStopDic Whether to use the default stop words.
##' @return A data.frame.
##' @author Jian Li <\email{rweibo@@sina.com}>
##' @examples
##' createWordFreq(c("a", "a", "b", "c"), onlyCN = FALSE, useStopDic = FALSE)
##' 

createWordFreq <- function(string, onlyCN = TRUE, stopwords = NULL, useStopDic = TRUE)
{
	string <- .verifyChar(string)
	
	if (identical(useStopDic, TRUE)) {
		stopwords <- .verifyChar(stopwords)
		.tmcnEnv <- get(".tmcnEnv", envir = .GlobalEnv)
		utils::data(STOPWORDS, envir = .tmcnEnv)
		STOPWORDS <- get("STOPWORDS", envir = .tmcnEnv)
		stopwords <- union(stopwords, STOPWORDS$word)
	} else {
		stopwords <- character()
	}
	
	if (onlyCN) {
		string.vec <- gsub("[^\u4e00-\u9fa5]", "", string)
	} else {
		#string.vec <- gsub("^[^\u4e00-\u9fa5A-z]*$", "", string)
		string.vec <- gsub("[^\u4e00-\u9fa5A-Za-z]", "", string)
	}
	string.vec <- string.vec[nzchar(string.vec)]
	string.vec <- string.vec[!string.vec %in% stopwords]
	
	if (length(string.vec) == 0) return(data.frame(word = character(), freq = integer(), stringsAsFactors = FALSE))
	
	string.table <- table(string.vec)
	OUT <- data.frame(word = names(string.table), freq = as.vector(string.table), stringsAsFactors = FALSE)
	OUT <- OUT[order(OUT$freq, decreasing = TRUE), ]
	
	return(OUT)
}

