

require(tmcn.word2vec)

TestFilePath <- system.file("tests", package = "tmcn.word2vec")
TrainingFile <- file.path(TestFilePath, "testdata", "questions-words.txt")
WorkPath <- tempdir()
ModelFile1 <- file.path(WorkPath, "output", "model1.bin")
res1 <- word2vec(TrainingFile, ModelFile1)

distance(res1$output_file, "think")












