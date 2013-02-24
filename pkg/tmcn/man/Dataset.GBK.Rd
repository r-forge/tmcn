\name{Dataset.GBK}
\alias{Dataset.GBK}
\docType{data}
\title{GBK character set}
\description{
GBK character set including all Phonetic.
}
\usage{data(Dataset.GBK)}
\format{
  A data frame with 3 columns.
  \describe{
    \item{\code{GBK}}{Chinese characters in UTF-8}
    \item{\code{py0}}{Unique phonetic of each character}
    \item{\code{py}}{Phonetics string of each character}
  }
}

\examples{
data(Dataset.GBK, envir = .tmcnEnv)
}
\keyword{datasets}
