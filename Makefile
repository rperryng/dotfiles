# Package bundles
PKG_DIR = $(CURDIR)/modules
ALL_PKGS = $(sort $(basename $(dir $(wildcard modules/*/))))
LOCAL_PKGS = $(sort $(notdir $(wildcard ./local*)))

# TODO: just do this with make?
PACKAGE_NAMES = $(shell ls -d ./modules/*/ | sed "s|./modules||" | sed "s|/||g")

# XDG directories
XDG_CONFIG_HOME := $(HOME)/.config
XDG_DATA_HOME := $(HOME)/.local/share
XDG_CACHE_HOME := $(HOME)/.cache
# Non-standard
XDG_BIN_HOME := $(HOME)/.local/bin
XDG_LIB_HOME := $(HOME)/.local/lib
XDG_OPT_HOME := $(HOME)/.local/opt

# Dotfiles
DOTFILES_DIR := $(HOME)/.dotfiles
BOGUS_LINKS_PATH := $(DOTFILES_DIR)/.stow-bogus-links

# Subdirectories with make files
SUBDIRS = $(sort $(basename $(dir $(wildcard */Makefile))))
PKG_MAKEFILES = $(SUBDIRS:/=)

all: setup prepare-dirs link

shellcheck:
	@shellcheck $$(find . -type f -path '*/bin/**' ! -name '*.*' ! -name 'time-zsh')
	@shellcheck $$(find . -name '*.sh')

check-shfmt:
	@shfmt -i 2 -ci -l $$(find . -type f -path '*/bin/**' ! -name '*.*')
	@shfmt -i 2 -ci -l $$(find . -name '*.sh')

lint: shellcheck check-shfmt

setup:
	@stow -t $(HOME) -d . -S etc

prepare-dirs:
	@mkdir -p $(CURDIR)/local
	@mkdir -p $(HOME)/.ssh/config.d
	@mkdir -p $(XDG_CONFIG_HOME)/profile.d
	@mkdir -p $(XDG_CONFIG_HOME)/shell.d
	@mkdir -p $(XDG_CONFIG_HOME)/git
	@mkdir -p $(XDG_CONFIG_HOME)/less
	@mkdir -p $(XDG_DATA_HOME)/zsh
	@mkdir -p $(XDG_CACHE_HOME)/less
	@mkdir -p $(XDG_BIN_HOME)
	@mkdir -p $(XDG_LIB_HOME)
	@mkdir -p $(XDG_OPT_HOME)
	@mkdir -p $(HOME)/code
ifeq ($(shell uname), Darwin)
	@mkdir -p $(XDG_CONFIG_HOME)/hammerspoon
	@mkdir -p $(XDG_CONFIG_HOME)/homebrew
endif

link: prepare-dirs setup
	@stow -t $(HOME) -d $(CURDIR) -S local
	@stow -t $(HOME) -d $(PKG_DIR) -S $(PACKAGE_NAMES)

unlink:
	@stow -t $(HOME) -D local
	@stow -t $(HOME) -d $(PKG_DIR) -D $(filter-out stow,$(ALL_PKGS))

.PHONY: chklink
chklink:
	@echo "\n--- Default package files currently unlinked ---\n"
	@stow -n -v -t $(HOME) -d $(PKG_DIR) -S $(PACKAGE_NAMES)
	@echo "\n--- Local packages currently unlinked ---\n"
	@stow -n -v -t $(HOME) -d $(CURDIR) -S local
	@echo "\n--- Bogus links ---\n"
	@rm -f .stow-bogus-links
	@chkstow -a -b -t $(XDG_CONFIG_HOME) | sed 's/Bogus link: //' >> $(BOGUS_LINKS_PATH)
	@chkstow -a -b -t $(XDG_DATA_HOME) >> $(BOGUS_LINKS_PATH)
	@chkstow -a -b -t $(XDG_BIN_HOME) >> $(BOGUS_LINKS_PATH)
	@chkstow -a -b -t $(XDG_LIB_HOME) >> $(BOGUS_LINKS_PATH)
	@chkstow -a -b -t $(XDG_OPT_HOME) >> $(BOGUS_LINKS_PATH)

	@cat .stow-bogus-links

	@if [ -s $(BOGUS_LINKS_PATH) ]; then \
		echo "run 'make clnlink' to remove these files"; \
	fi

.PHONY: clnlink
clnlink:
	@if [ ! -f $(BOGUS_LINKS_PATH) ]; then \
	  echo "no bogus links to clean"; \
	  exit 1; \
	fi

	@if [ ! -s $(BOGUS_LINKS_PATH) ]; then \
		echo ""; \
		exit 1; \
	fi

	@echo "deleting bogus links at $(BOGUS_LINKS_PATH)"
	@cat $(BOGUS_LINKS_PATH)
	@cat $(BOGUS_LINKS_PATH) | xargs rm

.PHONY: list-pkgs
list-pkgs:
	@echo $(ALL_PKGS:/=)

.PHONY: list-makefiles
list-makefiles:
	@echo $(PKG_MAKEFILES)

.PHONY: $(PKG_MAKEFILES)
$(PKG_MAKEFILES):
	@echo $@
	@$(MAKE) -C $@ $(MAKECMDGOALS)

.PHONY: .DEFAULT
.DEFAULT:
	@for dir in $(PKG_MAKEFILES); do \
		$(MAKE) -C $$dir $(MAKECMDGOALS); \
	done
