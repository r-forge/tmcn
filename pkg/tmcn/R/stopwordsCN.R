
##' Return Chinese stop words.
##' 
##' @title Return Chinese stop words.
##' @param stopwords A character vector of stop words.
##' @param useStopDic Whether to use the default stop words.
##' @return A vector of stop words.
##' @author Jian Li <\email{rweibo@@sina.com}>
##' @examples
##' stopwordsCN()[1:5]

stopwordsCN <- function(stopwords = NULL, useStopDic = TRUE)
{
	stopwords <- .verifyChar(stopwords)
	.tmcnEnv <- get(".tmcnEnv", envir = .GlobalEnv)
	utils::data(STOPWORDS, envir = .tmcnEnv)
	STOPWORDS <- get("STOPWORDS", envir = .tmcnEnv)
	if (identical(useStopDic, TRUE)) {
		stopwords <- union(stopwords, STOPWORDS$word)
	}
	return(stopwords)
}

