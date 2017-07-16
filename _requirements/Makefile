# a list of all .in files
objects = $(wildcard *.in)

# a list of .txt files for each .in (will be used to create .txt files)
outputs := $(objects:.in=.txt)

#------------------------------
# helpers
#------------------------------

define echo_help
	@echo $(call format_info, $(1))"\t"$(call format_success, $(2))
endef

define format_warning
	"\033[33m$(1)\033[0m"
endef

define format_danger
	"\033[31m$(1)\033[0m"
endef

define format_success
	"\033[32m$(1)\033[0m"
endef

define format_info
	"\033[34m$(1)\033[0m"
endef

#------------------------------
# help
#------------------------------

.PHONY: help
help:
	@$(call echo_help, "all", "builds all .txt files")
	@$(call echo_help, "check", "checks if pip-tools is installed")
	@$(call echo_help, "clean", "deletes all .txt files \(run before ``make all`` to force update all dependencies\)")

#------------------------------
# all
# builds all .txt files
#------------------------------

.PHONY: all
all: $(outputs)

# recipes for how to build .txt files

%.txt: %.in
	pip-compile -v --output-file $@ $<

# define dependencies
test.txt: base.txt

#------------------------------
# check
# checks if pip-tools is installed,
# which is needed to re-build the .txt files
#------------------------------

.PHONY: check
check:
	@which pip-compile > /dev/null

#------------------------------
# clean
# deletes all .txt files
# (run before ``make all`` to force update all dependencies)
#------------------------------

.PHONY: clean
clean: check
	- rm *.txt
