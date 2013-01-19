\name{crfLearn}
\alias{crfLearn}
\title{CRF learn.}
\usage{
  crfLearn(templet_file, training_file, model_file,
    sigma = 1, freq_thresh = 0, thread_num = 1,
    max_iter = 10000, eta = 1e-04,
    algorithm = c("CRFs", "AP", "PA", "L1CRFs"), depth = 5,
    isfast = TRUE)
}
\arguments{
  \item{templet_file}{Path of templet file.}

  \item{training_file}{Path of training file.}

  \item{model_file}{Path of model file.}

  \item{sigma}{Gaussian prior or L1 regularizer. Default
  value is 1.}

  \item{freq_thresh}{Frequency threshold. Default value is
  0.}

  \item{thread_num}{Thread number. Default value is 1.}

  \item{max_iter}{Max iteration number. Default value is
  10000.}

  \item{eta}{Controls training precision. Default value is
  0.0001.}

  \item{algorithm}{Algorithm: CRFs means 'CRFs'; AP means
  'Averaged Perceptron'; PA means 'Passive Aggressive';
  L1CRFs means 'L1 CRFs'. Default value is 0.}

  \item{depth}{LBFGS depth. Default value is 5.}

  \item{isfast}{A logical value. TRUE means fast train crf,
  FALSE means slow but requires less memory. Default value
  is TRUE.}
}
\value{
  No results.
}
\description{
  CRF learn.
}
\author{
  Jian Li <\email{rweibo@sina.com}>
}

