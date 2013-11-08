

require(tmcn.crfpp)

# Learn
TestFilePath <- system.file("tests", package = "tmcn.crfpp")
TempletFile <- file.path(TestFilePath, "testdata", "chunking_template")
TrainingFile <- file.path(TestFilePath, "testdata", "chunking_train")
WorkPath <- tempdir()
ModelFile1 <- file.path(WorkPath, "output", "model1")
ModelFile2 <- file.path(WorkPath, "output", "model2")
res1 <- crflearn(TempletFile, TrainingFile, ModelFile1)
res2 <- crflearn(TempletFile, TrainingFile, ModelFile2, max_iter = 50, algorithm = "AP")

# Test
KeyFile <- file.path(TestFilePath, "testdata", "chunking_key")
ResultFile1 <- file.path(WorkPath, "output", "result1")
test1 <- crftest(ModelFile1, KeyFile, ResultFile1)











