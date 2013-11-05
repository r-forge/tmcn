\name{word2vec}
\alias{word2vec}
\title{Train a model by word2vec.}
\usage{
  word2vec(train_file, output_file, binary = 1)
}
\arguments{
  \item{train_file}{Path of the train file.}

  \item{output_file}{Path of the output file.}

  \item{binary}{Whether to output binary, default is 1
  means binary.}
}
\value{
  A list with the input.
}
\description{
  Train a model by word2vec.
}
\details{
  The word2vec tool takes a text corpus as input and
  produces the word vectors as output. It first constructs
  a vocabulary from the training text data and then learns
  vector representation of words. The resulting word vector
  file can be used as features in many natural language
  processing and machine learning applications.
}
\author{
  Jian Li <\email{rweibo@sina.com}>
}

