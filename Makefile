#!usr/bin/make -f
# All commands are run as R functions rather than shell commands so that it will work easily on any Windows machine, even if the Windows machine isn't properly set up with all the right tools

all: README.md

clean:
	Rscript -e 'suppressWarnings(file.remove("README.md", "vignettes/ezknitr.md"))'

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

README.md : vignettes/ezknitr.Rmd
#	echo "Rendering the ezknitr vignette"
	Rscript -e 'rmarkdown::render("vignettes/ezknitr.Rmd", output_format = "md_document")'
#	echo "Correcting image paths"
#	sed -i -- 's,../inst,inst,g' vignettes/ezknitr.md
	Rscript -e 'file <- gsub("../inst", "inst", readLines("vignettes/ezknitr.md")); writeLines(file, "vignettes/ezknitr.md")'
#	echo "Copying output to README.md"
#	cp vignettes/ezknitr.md README.md
	Rscript -e 'file.copy("vignettes/ezknitr.md", "README.md", overwrite = TRUE)'
	Rscript -e 'suppressWarnings(file.remove("vignettes/ezknitr.md"))'