\name{crftest}
\alias{crftest}
\title{CRF test.}
\usage{
  crftest(model_file, key_file, result_file, margin = 0,
    seqp = 0, nbest = 1)
}
\arguments{
  \item{model_file}{Path of model file.}

  \item{key_file}{Path of key file.}

  \item{result_file}{Path of result file.}

  \item{margin}{Whether output margin probability.}

  \item{seqp}{Whether output label sequence probability.}

  \item{nbest}{Output n best results.}
}
\value{
  No results.
}
\description{
  CRF test.
}
\author{
  Jian Li <\email{rweibo@sina.com}>
}

