SHELL = /bin/bash
MD_DIR      := markdown/
CSS_DIR     := templates/
TMPL_DIR    := templates/
BUILD_DIR   := build/
ASSETS_DIR  := assets/
YAML_DATA   := /.site.yaml

DEFAULT_TMPL    := template.html
DEFAULT_CSS := $(TMPL_DIR)style.css

MD_FILES    := $(shell find $(MD_DIR) -type f -name "*.md")
HTML_FILES  := $(patsubst $(MD_DIR)%.md,$(BUILD_DIR)%.html,$(MD_FILES))
CSS_FILES   := $(patsubst $(CSS_DIR)%,$(BUILD_DIR)$(CSS_DIR)%, \
	       $(wildcard $(CSS_DIR)*.css))
TMPL_FILES  := $(shell find $(TMPL_DIR) -type f -name "*.html")

CUSTOM_TMPL = $(shell sed -n 's/^template: *\([^ ]*\) */\1/p' $<)

.PHONY: all upload clean

all: $(YAML_DATA) $(CSS_FILES) $(HTML_FILES) $(BUILD_DIR)$(ASSETS_DIR) 

$(YAML_DATA):
	./makeyaml.sh

$(BUILD_DIR)$(CSS_DIR)%.css: $(CSS_DIR)%.css
	if [ ! -d "$(@D)" ]; then mkdir -p "$(@D)"; fi
	cp $< $@

$(BUILD_DIR)%.html: $(MD_DIR)%.md $(TMPL_FILES)
	if [ ! -d "$(@D)" ]; then mkdir -p "$(@D)"; fi
	if grep -q '^toc: true' $< ; then \
	pandoc --template=$(TMPL_DIR)$(if $(CUSTOM_TMPL),$(CUSTOM_TMPL),$(DEFAULT_TMPL)) \
	--css=$(shell sed 's/[^/]//g; s/\//..\//g' <<<$(@D))$(DEFAULT_CSS) \
	--metadata-file=.site.yml --toc \
	--lua-filter=lighty.lua \
	-o "$@" "$<" ; else \
	pandoc --template=$(TMPL_DIR)$(if $(CUSTOM_TMPL),$(CUSTOM_TMPL),$(DEFAULT_TMPL)) \
	--lua-filter=lighty.lua \
	--css=$(shell sed 's/[^/]//g; s/\//..\//g' <<<$(@D))$(DEFAULT_CSS) \
	--metadata-file=.site.yml \
	-o "$@" "$<" ; fi

$(BUILD_DIR)$(ASSETS_DIR):
	if [ -d "$(ASSETS_DIR)" ]; then \
	rsync -rupE --exclude '*\.sh' $(ASSETS_DIR) $(@D); \
	fi

upload: $(HTML_FILES)
	rsync -rtvzP $(BUILD_DIR) user@example.org:/path/to/website

clean:
	rm -rf $(BUILD_DIR)
