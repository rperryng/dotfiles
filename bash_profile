# Base16 shell theming
# BASE16_SHELL=$HOME/.config/base16-shell/
# [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/# profile_helper.sh)"

# /base16 Terminal theming
# source ~/.config/base16-gnome-terminal/base16-ocean.dark.sh
BASE16_SCHEME="ocean.dark"
BASE16_SHELL="$HOME/.config/base16-shell/base16-$BASE16_SCHEME.sh"
[[ -s $BASE16_SHELL ]] && . $BASE16_SHELL

# PS1
WHITE="\[\033[01;37m\]"
BLUE="\[\033[01;34m\]"
GREEN="\[\033[01;32m\]"
YELLOW="\[\033[01;33m\]"
export PS1="\n$WHITE($BLUE\h$WHITE) $GREEN\u$WHITE at $YELLOW\w$WHITE\$(__git_ps1)\n\\[$(tput sgr0)\]\$ "

# Path addons
PATH=$PATH:~/Android/Sdk/platform-tools
PATH=$PATH:~/Android/Sdk/tools
PATH=$PATH:~/Devtools
PATH=$PATH:~/.rbenv/bin
PATH=$PATH:/opt/hadoop-2.7.2/bin
PATH=$PATH:/opt/scala-2.11.6/bin
PATH=$PATH:/opt/spark-2.1.0-bin-hadoop2.7/bin

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

alias py="python3"

# Show all matching entries, and cycle through them
bind "TAB:menu-complete"
bind "set menu-complete-display-prefix on"
bind "set show-all-if-ambiguous on"

eval "$(rbenv init -)"

[ -s "/home/ryan/.scm_breeze/scm_breeze.sh" ] && source "/home/ryan/.scm_breeze/scm_breeze.sh"
