
# Logfile
#######################################################
LOGDIR=/var/log/groots/gmetrics/
LOGFILE=$LOGDIR/"$SCRIPTNAME".log
if [ ! -d $LOGDIR ]
then
        mkdir -p $LOGDIR
elif [ ! -f $LOGFILE ]
then
        touch $LOGFILE
fi

# Logger function
#######################################################
log () {
while read line; do echo "[`date +"%Y-%m-%dT%H:%M:%S,%N" | rev | cut -c 7- | rev`][$SCRIPTNAME]: $line"| tee -a $LOGFILE 2>&1 ; done
}

#locate pkexec >/dev/null && { pkexec chmod 0440 /etc/sudoers | log;} || sudo chmod 0440 /etc/sudoers | log
locate pkexec >/dev/null && { echo "yes" | log;} || sudo echo "no" | log
