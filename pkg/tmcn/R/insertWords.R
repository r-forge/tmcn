
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
		if (!suppressWarnings(require("Rwordseg", quietly = TRUE, warn.conflicts = FALSE))) {
			Rwordseg::insertWords(strwords)
		}
	} else {
		if (suppressWarnings(require("jiebaR", quietly = TRUE, warn.conflicts = FALSE))) {
			if (exists("jiebaAnalyzer", envir = .tmcnEnv)) {
				jiebaAnalyzer <- get("jiebaAnalyzer", envir = .tmcnEnv)
			} else {
				jiebaAnalyzer <- worker(bylines = TRUE)
			}
			new_user_word(jiebaAnalyzer, strwords, tags = rep("userDefine", length(strwords)))
			assign("jiebaAnalyzer", jiebaAnalyzer, envir = .tmcnEnv)
		}
	} 
}






