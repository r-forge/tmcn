
test.strtrimspace <- function() {
	str1 <- strtrimspace(" \n\thaha\t")
	checkEquals(str1, "haha")
}
