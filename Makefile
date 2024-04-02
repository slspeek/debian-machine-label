# SHELL=/bin/bash
BUILD=build
MAIN_NAME=debian-machine-label
LATEX_IMAGE=leplusorg/latex:sha-4a17317
PDFLATEX_CMD=docker run --rm -t --workdir=/tmp --user="$(shell id -u):$(shell id -g)" --net=none -e TEXINPUTS=src:$(BUILD): -v "$(shell pwd):/tmp" $(LATEX_IMAGE) pdflatex -output-directory $(BUILD) $(MAIN_NAME).tex


default: clean view

view: test
	evince $(BUILD)/$(MAIN_NAME).pdf

clean:
	rm -rf $(BUILD)
	
prepare:
	mkdir -p $(BUILD)

generate_pdf: prepare
	BUILD=$(BUILD) PASSWORD=${PASSWORD} BOOTMENUKEY=${BOOTMENUKEY} ./spec.sh
	$(PDFLATEX_CMD)

test: prepare
	BUILD=$(BUILD) PROBE_CMD="cat test/hw-probe-output.txt" PASSWORD=tux BOOTMENUKEY=F9 ./spec.sh
	$(PDFLATEX_CMD)
