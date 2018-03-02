
##' A function segment Chinese sentence into words.
##' 
##' The function \code{segmentCN} is originated from the '\code{Rwordseg}' package. 
##' If '\code{Rwordseg}' was installed successfully (JRE and '\code{rJava}' package 
##' are required), using 'Rwordseg::segmentCN' directly may be the easiest choice. 
##' More detailed can be found in \url{http://jianl.org/cn/R/Rwordseg.html}.
##' 
##' In this package the function \code{segmentCN} is a wrapper of '\code{jiebaR}', 
##' which can be easily installed from CRAN. This function \code{segmentCN} only 
##' provide some basic functionalities of '\code{jiebaR}'. More detailed can be 
##' found in \url{http://qinwenfeng.com/jiebaR}.
##'
##' The function \code{insertWords} is used to add new words into dictionary temporarily.
##' If you want to manage your own dictionary, please select either '\code{Rwordseg}' or 
##' '\code{jiebaR}' package for segmentation.
##' @title Sengment a sentence.
##' @aliases insertWords
##' @usage
##' segmentCN(strwords, package = c("jiebaR", "Rwordseg"), nature = FALSE, 
##'   nosymbol = TRUE, useStopDic = FALSE, returnType = c("vector", "tm"))
##' insertWords(inswords, package = c("jiebaR", "Rwordseg")) 
##' @param strwords A string vector of Chinese sentences in UTF-8.
##' @param package Use which package, "jiebaR" or "Rwordseg"?
##' @param nature Whether to recognise the nature of the words.
##' @param nosymbol Whether to keep symbols in the sentence.
##' @param useStopDic Whether to use the default stop words.
##' @param returnType Default is a string vector but we also can choose 'tm' 
##' to output a single string separated by space so that it can be used by \code{\link[tm]{Corpus}} directly. 
##' @param inswords A string vector of words will be added into dictionary.
##' @return a vector of words (list if input is vecter) which have been segmented or the path of output file.
##' @author Jian Li <\email{rweibo@@sina.com}>
##' @keywords NLP
##' 

segmentCN <- function(strwords, package = c("jiebaR", "Rwordseg"), 
		nature = FALSE, nosymbol = TRUE, useStopDic = FALSE, 
		returnType = c("vector", "tm")) 
{
	if (!is.character(strwords)) stop("Please input character!")
	package <- match.arg(package)
	returnType <- match.arg(returnType)
	.tmcnEnv <- .verifyEnv()
	
	if (package == "Rwordseg") {
		cat("Please load the package Rwordseg: library(Rwordseg) \n") 
		invisible(NULL)
	} else {
		if (suppressWarnings(requireNamespace("jiebaR", quietly = TRUE))) {
			package <- "jiebaR"
		} else {
			stop("Package \"jiebaR\" is required!")
		}
	}
	
	if (package == "jiebaR") {
		if (!exists(".tmcnEnv", envir = .GlobalEnv)) {
			envir0 = as.environment(1)
			assign(".tmcnEnv", new.env(), envir = envir0)
		}
		if (!exists("jiebaAnalyzer", envir = .tmcnEnv)) {
			jiebaAnalyzer <- jiebaR::worker(bylines = TRUE)
			assign("jiebaAnalyzer", jiebaAnalyzer, envir = .tmcnEnv)
		} else {
			jiebaAnalyzer <- get("jiebaAnalyzer", envir = .tmcnEnv)
		}
		
		jiebaAnalyzer$symbol <- !nosymbol
		OUT <- jiebaR::segment(strwords, jiebaAnalyzer)
		
		if (useStopDic) {
			STOPWORDS <- .getStopWords()
			OUT <- lapply(OUT, setdiff, STOPWORDS$word)
		}
		if (nature) OUT <- lapply(OUT, jiebaR::vector_tag, jiebaAnalyzer)
		if (returnType == "tm") OUT <- sapply(OUT, paste, collapse = " ")
		if (length(OUT) == 1) OUT <- OUT[[1]]
		return(OUT)
	}
	
}


insertWords <- function(inswords, package = c("jiebaR", "Rwordseg")) 
{
	package <- match.arg(package)
	if (package == "Rwordseg") {
		cat("Please load the package \"Rwordseg\": library(Rwordseg) \n")
	} else {
		if (suppressWarnings(requireNamespace("jiebaR", quietly = TRUE))) {
			.tmcnEnv <- .verifyEnv()
			if (exists("jiebaAnalyzer", envir = .tmcnEnv)) {
				jiebaAnalyzer <- get("jiebaAnalyzer", envir = .tmcnEnv)
			} else {
				jiebaAnalyzer <- jiebaR::worker(bylines = TRUE)
			}
			jiebaR::new_user_word(jiebaAnalyzer, inswords, tags = rep("userDefine", length(inswords)))
			assign("jiebaAnalyzer", jiebaAnalyzer, envir = .tmcnEnv)
		}
	} 
}



