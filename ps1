# PS1
WHITE="\[\033[01;37m\]"
BLUE="\[\033[01;34m\]"
GREEN="\[\033[01;32m\]"
YELLOW="\[\033[01;33m\]"
export PS1="\n$WHITE($BLUE\h$WHITE) $GREEN\u$WHITE at $YELLOW\w$WHITE\$(__git_ps1)\n\\[$(tput sgr0)\]\$ "
