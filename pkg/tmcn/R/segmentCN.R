
##' A function segment Chinese sentence into words.
##' 
##' Either package "Rwordseg" (\url{http://jianl.org/cn/R/Rwordseg.html}) or "jiebaR" (\url{http://qinwenfeng.com/jiebaR}) is required.
##' @title Sengment a sentence.
##' @param strwords A Chinese sentence in UTF-8.
##' @param package Use which package, "Rwordseg" or "jiebaR"?
##' @param nature Whether to recognise the nature of the words.
##' @param nosymbol Whether to keep symbols in the sentence.
##' @param returnType Default is a string vector but we also can choose 'tm' 
##' to output a single string separated by space so that it can be used by \code{\link[tm]{Corpus}} directly. 
##' @param ... Other arguments of Rwordseg.
##' @return a vector of words (list if input is vecter) which have been segmented or the path of output file.
##' @author Jian Li <\email{rweibo@@sina.com}>
##' @examples \dontrun{
##' segmentCN("hello world!")
##' }

segmentCN <- function(strwords, package = c("Rwordseg", "jiebaR"), 
		nature = FALSE, nosymbol = TRUE, returnType = c("vector", "tm"), ...) 
{
	if (!is.character(strwords)) stop("Please input character!")
	package <- match.arg(package)
	returnType <- match.arg(returnType)
	
	if (package == "Rwordseg") {
		if (!suppressWarnings(require("Rwordseg", quietly = TRUE, warn.conflicts = FALSE))) {
			if (suppressWarnings(require("jiebaR", quietly = TRUE, warn.conflicts = FALSE))) {
				package <- "jiebaR"
			} else {
				stop("Either package \"Rwordseg\" or \"jiebaR\" is required!")
			}
		} 
	} else {
		if (suppressWarnings(require("jiebaR", quietly = TRUE, warn.conflicts = FALSE))) {
			package <- "jiebaR"
		} else {
			stop("Either package \"Rwordseg\" or \"jiebaR\" is required!")
		}
	}
	
	if (package == "Rwordseg") {
		OUT <- Rwordseg::segmentCN(strwords = strwords, nature = nature, nosymbol = nosymbol, returnType = returnType, ...)
	}
	
	if (package == "jiebaR") {
		if (!exists(".tmcnEnv", envir = .GlobalEnv)) {
			assign(".tmcnEnv", new.env(), envir = .GlobalEnv)
		}
		if (!exists("jiebaAnalyzer", envir = .tmcnEnv)) {
			jiebaAnalyzer <- worker(bylines = TRUE)
			assign("jiebaAnalyzer", jiebaAnalyzer, envir = .tmcnEnv)
		} else {
			jiebaAnalyzer <- get("jiebaAnalyzer", envir = .tmcnEnv)
		}
		
		jiebaAnalyzer$symbol <- !nosymbol
		OUT <- segment(strwords, jiebaAnalyzer)
		
		if (nature) OUT <- lapply(OUT, vector_tag, jiebaAnalyzer)
		if (returnType == "tm") OUT <- sapply(OUT, paste, collapse = " ")
		if (length(OUT) == 1) OUT <- OUT[[1]]
	}
	
	return(OUT)
}


