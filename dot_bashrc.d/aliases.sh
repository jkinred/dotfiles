if [ -x /bin/grep ];
then
    alias showbigfiles="sudo -E GLOBIGNORE=".:.." du -hsx * .[a-zA-Z]* | grep -E '([0-9][0-9][0-9]M|[0-9]G)' | sort -h"
fi

alias tree="tree --charset=ascii"
alias yamlcheck='python -c "import yaml,sys;yaml.safe_load(sys.stdin)"'
alias gpg='gpg2'
alias sha512="python3 -c 'import crypt; print(crypt.crypt(\"test\", crypt.mksalt(crypt.METHOD_SHA512)))'"
alias yt="youtube-dl --extract-audio --audio-format mp3 --audio-quality 0"
alias pwgen-secure="pwgen -ynC 20"
alias rg="rg --smart-case --hidden --glob '!.git/'"
alias diff='diff --color --unified'
alias gpaste-reset='killall gpaste-daemon && gpaste-client add foo && killall gpaste-daemon && gpaste-client add bar'
alias vi=nvim
alias lg=lazygit
alias gpa='gpaste-client add'
alias wakenas='wol f4:39:09:02:1b:1f'
