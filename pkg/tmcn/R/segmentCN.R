
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

segmentCN <- function(strwords, package = c("jiebaR", "Rwordseg"), 
		nature = FALSE, nosymbol = TRUE, returnType = c("vector", "tm"), ...) 
{
	if (!is.character(strwords)) stop("Please input character!")
	package <- match.arg(package)
	returnType <- match.arg(returnType)
	.tmcnEnv <- get(".tmcnEnv", envir = .GlobalEnv)
	
	if (package == "Rwordseg") {
		cat("Please load the package Rwordseg: library(Rwordseg) \n") 
		OUT <- NULL
	} else {
		if (suppressWarnings(requireNamespace("jiebaR", quietly = TRUE))) {
			package <- "jiebaR"
		} else {
			stop("Package \"jiebaR\" is required!")
		}
	}
	
	
	if (package == "jiebaR") {
		if (!exists(".tmcnEnv", envir = .GlobalEnv)) {
			assign(".tmcnEnv", new.env(), envir = .GlobalEnv)
		}
		if (!exists("jiebaAnalyzer", envir = .tmcnEnv)) {
			jiebaAnalyzer <- jiebaR::worker(bylines = TRUE)
			assign("jiebaAnalyzer", jiebaAnalyzer, envir = .tmcnEnv)
		} else {
			jiebaAnalyzer <- get("jiebaAnalyzer", envir = .tmcnEnv)
		}
		
		jiebaAnalyzer$symbol <- !nosymbol
		OUT <- jiebaR::segment(strwords, jiebaAnalyzer)
		
		if (nature) OUT <- lapply(OUT, jiebaR::vector_tag, jiebaAnalyzer)
		if (returnType == "tm") OUT <- sapply(OUT, paste, collapse = " ")
		if (length(OUT) == 1) OUT <- OUT[[1]]
	}
	
	return(OUT)
}


