# Solarized colours
NOCOLOR="\[\033[00m\]"
BASE02="\[\033[30m\]"
BASE03="\[\033[01;30m\]"
RED="\[\033[31m\]"
ORANGE="\[\033[01;31m\]"
GREEN="\[\033[32m\]"
BASE01="\[\033[01;32m\]"
YELLOW="\[\033[33m\]"
BASE00="\[\033[01;33m\]"
BLUE="\[\033[34m\]"
BASE0="\[\033[01;34m\]"
MAGENTA="\[\033[35m\]"
VIOLET="\[\033[01;35m\]"
CYAN="\[\033[36m\]"
BASE1="\[\033[01;36m\]"
BASE2="\[\033[37m\]"
BASE3="\[\033[01;37m\]"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval `dircolors ~/.dircolors`
    alias ls='ls --color=auto'
    alias egrep='egrep --color=auto'
fi
