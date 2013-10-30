

require(tmcn.crfpp)

TestPath <- system.file("tests", package = "tmcn.crfpp")
TempletFile <- file.path(TestPath, "testdata", "chunking_template")
TrainingFile <- file.path(TestPath, "testdata", "chunking_train")
ModelFile1 <- file.path(TestPath, "output", "model1")
ModelFile2 <- file.path(TestPath, "output", "model2")

res1 <- crflearn(TempletFile, TrainingFile, ModelFile1)
res2 <- crflearn(TempletFile, TrainingFile, ModelFile2, max_iter = 50, algorithm = "AP")












