if [ -z "#{DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]
then
    exec startx
fi

SCRIPTS_DIR=$HOME/.scripts

if [[ -d $SCRIPTS_DIR ]]
then
    for SHELL_SCRIPT in $(ls $SCRIPTS_DIR/*.sh)
    do
        sh $SHELL_SCRIPT &
    done
fi
