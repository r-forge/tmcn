
##' Return Chinese stop words.
##' 
##' @title Return Chinese stop words.
##' @param stopwords A character vector of stop words.
##' @param useStopDic Whether to use the default stop words.
##' @return A vector of stop words.
##' @author Jian Li <\email{rweibo@@sina.com}>
##' @examples
##' stopwordsCN("yes", useStopDic = FALSE)

stopwordsCN <- function(stopwords = NULL, useStopDic = TRUE)
{
	stopwords <- .verifyChar(stopwords)
	if (identical(useStopDic, TRUE)) {
		.tmcnEnv <- .verifyEnv()
		utils::data(STOPWORDS, envir = .tmcnEnv)
		STOPWORDS <- get("STOPWORDS", envir = .tmcnEnv)
		stopwords <- union(stopwords, STOPWORDS$word)
	}
	return(stopwords)
}

