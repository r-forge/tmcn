
test.isUTF8 <- function() {
	txt1 <- c("\u4E2D\u56FDR\u8BED\u8A00\u4F1A\u8BAE")
	txt2 <- iconv(txt1, "UTF-8", "GBK")
	txt3 <- txt1
	txt4 <- txt2
	Encoding(txt3) <- "GBK"
	Encoding(txt4) <- "UTF-8"
	checkEquals(isUTF8(c(txt1, txt2, txt3, txt4)), c(TRUE, FALSE, TRUE, TRUE))
	
	
	txt5 <- c("\u98DF\u54C1")
	txt6 <- iconv(txt5, "UTF-8", "GBK")
	txt7 <- c("\u98DF\u54C1\u77ED\u7F3A")
	txt8 <- iconv(txt7, "UTF-8", "GBK")
	checkEquals(isUTF8(c(txt5, txt7, txt8)), c(TRUE, TRUE, FALSE))
	
}
