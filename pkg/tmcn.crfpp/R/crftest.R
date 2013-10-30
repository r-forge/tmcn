
##' CRF test.
##' 
##' @title CRF test.
##' @param model_file Path of model file.
##' @param key_file Path of key file.
##' @param result_file Path of result file.
##' @param margin Whether output margin probability.
##' @param seqp Whether output label sequence probability.
##' @param nbest Output n best results.
##' @return No results.
##' @author Jian Li <\email{rweibo@@sina.com}>

crftest <- function(model_file, key_file, result_file,
		margin = 0, seqp = 0, nbest = 1)
{
	if (!file.exists(model_file)) stop("Can't find the model file!")
	if (!file.exists(key_file)) stop("Can't find the key file!")
	if (!file.exists(dirname(result_file))) dir.create(dirname(result_file), recursive = TRUE)
	
	OUT <- .C("CWrapper_crf_test", 
			model_file = as.character(model_file), 
			key_file = as.character(key_file), 
			result_file = as.character(result_file),
			margin = as.character(margin),
			seqp = as.character(seqp), 
			nbest = as.character(nbest))
	return(OUT)
}

