
##' Plot word clouds by using wordcloud package.
##' 
##' @title Plot word clouds.
##' @param string A character vector.
##' @param onlyCN Keep only chinese words. 
##' @param minwordlen Minimum of the words length.
##' @param minfreq Minimum of the words frequency.
##' @param ... Arguments for wordcloud. 
##' @return Nothing.
##' @author Jian Li <\email{rweibo@@sina.com}>
##' @keywords string
##' @examples \dontrun{
##' plotWordcloud(c(letters, LETTERS, 0:9), seq(1, 1000, len = 62))
##' }
##'

plotWordcloud <- function(string, onlyCN = TRUE, minwordlen = 2, minfreq = 5, ...) {
	
	if (!require(wordcloud, quietly = TRUE)) stop("'wordcloud' should be installed!")
	
	if (!identical(colnames(string), c("Word", "Freq"))) {
		string.df <- getWordFreq(string, onlyCN = onlyCN, useStopDic = TRUE)
	} else {
		string.df <- string
	}
	string.df <- string.df[nchar(string.df$Word) >= minwordlen, ]
	string.df <- string.df[string.df$Freq >= minfreq, ]
	
	wordcloud(string.df$Word, string.df$Freq, col = rainbow(length(string.df$Freq)), ...)
}


