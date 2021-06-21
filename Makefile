OUT_DIR=docs
IN_DIR=markdown
STYLES_DIR=styles
STYLE=chmduquesne
TITLE=Taylor Growden - Resume

all: html pdf

pdf:
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.pdf; \
		pandoc --standalone --template $(STYLES_DIR)/$(STYLE).tex \
			--from markdown --to context \
			-V papersize=A4 \
			-o $(OUT_DIR)/$$FILE_NAME.tex $$f > /dev/null; \
		context $(OUT_DIR)/$$FILE_NAME.tex --result=$(OUT_DIR)/$$FILE_NAME.pdf > $(OUT_DIR)/context_$$FILE_NAME.log 2>&1; \
		mv $$FILE_NAME.pdf $(OUT_DIR)/; \
		mv $$FILE_NAME.tuc $(OUT_DIR)/; \
	done

html: SHELL:=/bin/bash
html:
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		[[ ! -z "$$FILE_NAME" ]] && [ "$$FILE_NAME" == "resume" ] && FILE_NAME=index; \
		echo $$FILE_NAME.html; \
		pandoc --standalone -H $(STYLES_DIR)/$(STYLE).css \
			--from markdown --to html \
			--metadata pagetitle="${TITLE}" \
			-o $(OUT_DIR)/$$FILE_NAME.html $$f; \
	done

docx:
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.docx; \
		pandoc -s -S $$f -o $(OUT_DIR)/$$FILE_NAME.docx; \
	done

rtf:
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.rtf; \
		pandoc -s -S $$f -o $(OUT_DIR)/$$FILE_NAME.rtf; \
	done

watch:
	while true; do make; inotifywait -qre close_write .; done

clean:
	rm -f $(OUT_DIR)/*
