

require(tmcn.crfpp)

TestPath <- system.file("tests", package = "tmcn.crfpp")
ModelFile1 <- file.path(TestPath, "output", "model1")
KeyFile <- file.path(TestPath, "testdata", "chunking_key")
ResultFile1 <- file.path(TestPath, "output", "result1")

test1 <- crftest(ModelFile1, KeyFile, ResultFile1)













