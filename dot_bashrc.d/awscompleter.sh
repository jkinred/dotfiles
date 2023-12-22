if [ -x $(which aws_completer) ]
then
    complete -C '/bin/aws_completer' aws
fi
