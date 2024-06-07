# Build documentation in all relevant formats

%.pdf: %.md
	pandoc $< -o $@
