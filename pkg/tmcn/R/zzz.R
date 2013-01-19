# TODO: Add comment
# 
# Author: jli
###############################################################################

.onAttach <- function(libname, pkgname ){
	packageStartupMessage( paste("# Version:", utils:::packageDescription("tmcn", fields = "Version")) )
}

