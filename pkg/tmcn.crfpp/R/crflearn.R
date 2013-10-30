
##' CRF learn.
##' 
##' @title CRF learn.
##' @param templet_file Path of templet file.
##' @param training_file Path of training file.
##' @param model_file Path of model file.
##' @param sigma Gaussian prior or L1 regularizer. Default value is 1.
##' @param freq_thresh Frequency threshold. Default value is 0.
##' @param thread_num Thread number. Default value is 1.
##' @param max_iter Max iteration number. Default value is 10000.
##' @param eta Controls training precision. Default value is 0.0001.
##' @param algorithm Algorithm: CRFs means 'CRFs'; AP means 'Averaged Perceptron'; 
##'        PA means 'Passive Aggressive'; L1CRFs means 'L1 CRFs'. Default value is 0.
##' @param depth LBFGS depth. Default value is 5.
##' @param isfast A logical value. TRUE means fast train crf, FALSE means slow but 
##'        requires less memory. Default value is TRUE.
##' @return No results.
##' @author Jian Li <\email{rweibo@@sina.com}>

crflearn <- function(templet_file, training_file, model_file,
		sigma = 1, freq_thresh = 0, thread_num = 1, max_iter = 10000, 
		eta = 0.0001, algorithm = c("CRFs", "AP", "PA", "L1CRFs"), 
		depth = 5, isfast = TRUE)
{
	if (!file.exists(templet_file)) stop("Can't find the templet file!")
	if (!file.exists(training_file)) stop("Can't find the training file!")
	if (!file.exists(dirname(model_file))) dir.create(dirname(model_file), recursive = TRUE)
	
	algorithm <- match.arg(algorithm)
	algorithm <- which(c("CRFs", "AP", "PA", "L1CRFs") == algorithm) - 1
	if (!is.logical(isfast)) {
		stop("'isfast' should be a logical value!")
	} else {
		prior <- 1 - as.integer(isfast)
	}
	
	OUT <- .C("CWrapper_crf_learn", 
			templet_file = as.character(templet_file), 
			training_file = as.character(training_file), 
			model_file = as.character(model_file),
			sigma = as.character(sigma),
			freq_thresh = as.character(freq_thresh), 
			thread_num = as.character(thread_num), 
			max_iter = as.character(max_iter), 
			eta = as.character(eta),
			algorithm = as.character(algorithm),
			depth = as.character(depth),
			prior = as.character(prior))
	return(OUT)
}

