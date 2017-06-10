
##' Create a Chinese term-document matrix or a document-term matrix.
##' 
##' Package "tm" is required.
##' @title Create a Chinese term-document matrix or a document-term matrix.
##' @aliases createTDM
##' @usage
##' createDTM(string, tokenize = NULL, removePunctuation = TRUE, removeStopwords = TRUE)
##' createTDM(string, tokenize = NULL, removePunctuation = TRUE, removeStopwords = TRUE)
##' @param string A character vector.
##' @param tokenize A tokenizers function. 
##' @param removePunctuation Whether to remove the punctuations.
##' @param removeStopwords Whether to remove the stop words.
##' @return An object of class \code{TermDocumentMatrix} or class \code{DocumentTermMatrix}.
##' @author Jian Li <\email{rweibo@@sina.com}>
##' @keywords string
##' @examples \dontrun{
##' library(tmcn)
##' data(INTRO)
##' vec1 <- segmentCN(INTRO, returnType = "tm")
##' 
##' dtm1 <- createDTM(vec1)
##' inspect(dtm1)
##' 
##' tdm1 <- createTDM(vec1)
##' inspect(tdm1)
##' }
##'

createDTM <- function(string, tokenize = NULL, removePunctuation = TRUE, removeStopwords = TRUE) {
	
	if (suppressWarnings(!require("tm", quietly = TRUE, warn.conflicts = FALSE))) {
		stop("Package \"tm\" is required!")
	}
	
	corpus_m <- Corpus(VectorSource(string))
	if (removeStopwords) {
		corpus_m <- tm_map(corpus_m, removeWords, stopwordsCN())
	}
	
	if (is.null(tokenize)) tokenize <- .strsplit_space_tokenizer
	dtm_m <- DocumentTermMatrix(corpus_m, control = list(tokenize = tokenize, wordLengths = c(1, Inf), removePunctuation = removePunctuation) )
	colnames(dtm_m) <- toUTF8(colnames(dtm_m))
	return(dtm_m)
	
}

createTDM <- function(string, tokenize = NULL, removePunctuation = TRUE, removeStopwords = TRUE) {
	
	if (suppressWarnings(!require("tm", quietly = TRUE, warn.conflicts = FALSE))) {
		stop("Package \"tm\" is required!")
	}
	
	corpus_m <- Corpus(VectorSource(string))
	if (removeStopwords) {
		corpus_m <- tm_map(corpus_m, removeWords, c(stopwordsCN()))
	}
	
	if (is.null(tokenize)) tokenize <- .strsplit_space_tokenizer
	tdm_m <- TermDocumentMatrix(corpus_m, control = list(tokenize = tokenize, wordLengths = c(1, Inf), removePunctuation = removePunctuation) )
	rownames(tdm_m) <- toUTF8(rownames(tdm_m))
	return(tdm_m)
	
}
