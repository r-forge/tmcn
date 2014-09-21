
require(tmcn.word2vec)

# English characters
TrainingFile1 <- system.file("examples", "rfaq.txt", package = "tmcn.word2vec")
ModelFile1 <- file.path(tempdir(), "output", "model1.bin")

res1 <- word2vec(TrainingFile1, ModelFile1)
dist1 <- distance(res1$model_file, "object")
dist1


# Chinese characters in GBK encoding, for Windows
TrainingFile2 <- system.file("examples", "xsfh_GBK.txt", package = "tmcn.word2vec")
ModelFile2 <- file.path(tempdir(), "output", "model2.bin")

res2 <- word2vec(TrainingFile2, ModelFile2)
dist2 <- distance(res2$model_file, intToUtf8(c(33495, 20154, 20964)))
dist2


# Chinese characters in UTF-8 encoding, for *nix
TrainingFile3 <- system.file("examples", "xsfh_UTF8.txt", package = "tmcn.word2vec")
ModelFile3 <- file.path(tempdir(), "output", "model3.bin")

res3 <- word2vec(TrainingFile3, ModelFile3)
dist3 <- distance(res3$model_file, intToUtf8(c(33495, 20154, 20964)))
dist3


