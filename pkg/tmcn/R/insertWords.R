
##' Insert new words into dictionary.
##' 
##' @title Insert new words into dictionary.
##' @param strwords Vector of words.
##' @param package Use which package, "jiebaR" or "Rwordseg"?
##' @return No results.
##' @author Jian Li <\email{rweibo@@sina.com}>

insertWords <- function(strwords, package = c("jiebaR", "Rwordseg")) 
{
	package <- match.arg(package)
	if (package == "Rwordseg") {
		cat("Please load the package Rwordseg: library(Rwordseg) \n")
	} else {
		if (suppressWarnings(requireNamespace("jiebaR", quietly = TRUE))) {
			.tmcnEnv <- get(".tmcnEnv", envir = .GlobalEnv)
			if (exists("jiebaAnalyzer", envir = .tmcnEnv)) {
				jiebaAnalyzer <- get("jiebaAnalyzer", envir = .tmcnEnv)
			} else {
				jiebaAnalyzer <- jiebaR::worker(bylines = TRUE)
			}
			jiebaR::new_user_word(jiebaAnalyzer, strwords, tags = rep("userDefine", length(strwords)))
			assign("jiebaAnalyzer", jiebaAnalyzer, envir = .tmcnEnv)
		}
	} 
}






