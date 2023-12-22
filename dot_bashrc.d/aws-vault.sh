#for role in $( aws-vault list --profiles ); do
#  eval "assume_${role}() { export AWS_PROMPT='zenity'; export AWS_PROFILE=${role}; }"
#done

AWS_ASSUME_ROLE_TTL=3h
alias cnp="aws-vault exec cert-nonprod --"
alias cnpa="aws-vault exec cert-nonprod-admin --"
alias cpr="aws-vault exec cert-prod --"
alias cpra="aws-vault exec cert-prod-admin --"
