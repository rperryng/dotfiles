#!/usr/bin/env zsh

source "${XDG_OPT_HOME}/fzf/shell/completion.zsh"
source "${XDG_OPT_HOME}/fzf/shell/key-bindings.zsh"

# CTRL-Y - cd into the selected directory
bindkey -M emacs '^Y' fzf-cd-widget
bindkey -M vicmd '^Y' fzf-cd-widget
bindkey -M viins '^Y' fzf-cd-widget
