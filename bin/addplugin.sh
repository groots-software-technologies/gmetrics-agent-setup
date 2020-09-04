#!/bin/sh
#######################################################
# Program: To add Plugins on remote side
#
# Purpose:
#  This script adds Plugins to remote host directory /groots/monitoring/libexec
#  can be run in interactive.
#
# License:
#  This program is distributed in the hope that it will be useful,
#  but under groots software technologies @rights.
#
#######################################################

# Check for people who need help - aren't we all nice ;-)
#######################################################

#Set script name
#######################################################
SCRIPTNAME=$(basename $0)

# Import Hostname
#######################################################
HOSTNAME=$(hostname)

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


if [ "${1}" = "--help" -o "${#}" != "2" ];
then

    echo -e "Usage: $SCRIPTNAME -p [plugin name]

    OPTION                 DESCRIPTION
    -----------------------------------------
    --help                   help
    -p [plugin]            plugin name
    -----------------------------------------

    Usage: sh $SCRIPTNAME  -p [plugin name]
    Ex: sh addplugin.sh -p aws

    Plugin list: sms, appsensors, aws, backup, dns, docker, expiry, hardware, lamp, mithi, os, website, jvm ";
    exit 3;
fi


#######################################################
# Get user-given variables
#######################################################

while getopts "p:" Input;
do
case ${Input} in
p) PLUGINNAME=$OPTARG;;
*) echo "Usage: $SCRIPTNAME -p [plugin name]"
exit 3;
;;
esac
done

# Get OS 
#######################################################

OSNAME=$(cat /etc/*release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
echo "#######################################################" | log 
echo "Verifying if Subversion is present or not.." | log 

if [ $OSNAME = "CentOS" ]; then

    svn --version > /dev/null 2>&1

    if [ $? -eq 0 ]; then
    	echo "#######################################################" | log 
	echo "Svn is installed!" | log 
    else
        echo "Svn is not installed! Exiting now.." | log 
        echo "#######################################################"
        echo "To install svn: yum install subversion -y " | log 
        exit 3;
    fi
fi


if [ $OSNAME = "Ubuntu" ]; then

    svn --version > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "########################################################" | log 
	echo "Svn is installed!" | log 
    else
        echo "Svn is not installed! Exiting now.." | log 
	echo "########################################################" | log 
        echo "To install svn: apt install subversion  " | log 
        exit 3;
    fi
fi


# collecting git Username and Password
#######################################################

echo "#######################################################" | log 
echo "Enter git username:" | log 
read USERNAME

echo "#######################################################" | log 
echo "Enter git Password:" | log 
read -s PASSWORD

# Destination path
#######################################################

DEST="/groots/monitoring/libexec/"


# Svn command to Download plugin folder from git to /groots/monitoring/libexec
#######################################################


if [ "$PLUGINNAME" = "sms" ] || [ "$PLUGINNAME" = "Sms" ] || [ "$PLUGINNAME" = "SMS" ] ; then
    echo "Plugin "sms" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/sms --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "aws" ] || [ "$PLUGINNAME" = "Aws" ] || [ "$PLUGINNAME" = "AWS" ] ; then
    echo "Plugin "aws" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/aws --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "appsensors" ] || [ "$PLUGINNAME" = "Appsensors" ] || [ "$PLUGINNAME" = "APPSENSORS" ]; then
    echo "Plugin "appsensors" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/appsensors --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "expiry" ] || [ "$PLUGINNAME" = "Expiry" ] || [ "$PLUGINNAME" = "EXPIRY" ]; then
    echo "Plugin "expiry" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/expiry --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "backup" ] || [ "$PLUGINNAME" = "Backup" ] || [ "$PLUGINNAME" = "BACKUP" ]; then
    echo "Plugin "backup" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/backup --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "dns" ] || [ "$PLUGINNAME" = "DNS" ] || [ "$PLUGINNAME" = "dns" ]; then
    echo "Plugin "dns" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/dns --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "docker" ] || [ "$PLUGINNAME" = "Docker" ] || [ "$PLUGINNAME" = "DOCKER" ]; then
    echo "Plugin "docker" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/docker --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME successfully added. " | log 


elif [ "$PLUGINNAME" = "hardware" ] || [ "$PLUGINNAME" = "Hardware" ] || [ "$PLUGINNAME" = "HARDWARE" ]; then
    echo "Plugin "hardware" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/hardware --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "lamp" ] || [ "$PLUGINNAME" = "Lamp" ] || [ "$PLUGINNAME" = "LAMP" ]; then
    echo "Plugin "lamp" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/lamp --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "mithi" ] || [ "$PLUGINNAME" = "Mithi" ] || [ "$PLUGINNAME" = "MITHI" ]; then
    echo "Plugin "mithi" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/mithi --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "os" ] || [ "$PLUGINNAME" = "Os" ] || [ "$PLUGINNAME" = "OS" ]; then
    echo "Plugin "os" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/os --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "jvm" ] || [ "$PLUGINNAME" = "Jvm" ] || [ "$PLUGINNAME" = "JVM" ]; then
    echo "Plugin "jvm" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/jvm --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 


elif [ "$PLUGINNAME" = "website" ] || [ "$PLUGINNAME" = "Website" ] || [ "$PLUGINNAME" = "WEBSITE" ]; then
    echo "Plugin "website" selected to add in "$DEST" " | log 
    svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux/website --non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log 

else
    echo "#######################################################"
    echo "Invalid $PLUGINNAME. Enter valid plugin name."
    exit 3;
fi

# End Main logic.
#######################################################

