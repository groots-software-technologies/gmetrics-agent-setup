#!/bin/bash
#######################################################
# Program: To add Plugins on remote side
#
# Purpose:
#  This script adds Plugins to remote host directory /groots/metrics/libexec
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

SCRIPTNAME="addplugin.sh"

# Import Hostname
#######################################################
HOSTNAME=$(hostname)

# Logfile
#######################################################
LOGDIR=/var/log/groots/metrics/
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


# Usage details
######################################################

if [ "${1}" = "--help" -o "${#}" != "2" ];
then
echo -e "
Plugin list: sms, appsensors, aws, backup, dns, docker, elk, expiry, hardware, lamp, mithi, os, website, jvm, node, jenkins

OPTION                 DESCRIPTION
-----------------------------------------
--help                   help
-p [plugin]            plugin name
-----------------------------------------
Usage: sh $SCRIPTNAME  -p [plugin name]
Ex: sh addplugin.sh -p aws";
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

# type command is checking whether svn command present or not.
#######################################################

type svn >/dev/null 2>&1 || { echo >&2 "This plugin require "subversion" package, but it's not installed. Aborting."; exit 1; }

# collecting git Username and Password
#######################################################

user_input () {

echo "#######################################################" | log
echo "Enter git username:" | log
read USERNAME

echo "#######################################################" | log
echo "Enter git Password:" | log
read -s PASSWORD

}

# Destination path
#######################################################
DEST="/groots/metrics/libexec/"

# Svn command to Download plugin folder from git to /groots/metrics/libexec
#######################################################

copy_plugin () {

SVNCMD="--non-interactive --no-auth-cache --username $USERNAME --password "$PASSWORD" $DEST"
GITPATH="svn checkout https://github.com/grootsadmin/gmetrics-plugins/trunk/os/linux"

if [ "$PLUGINNAME" = "sms" ] || [ "$PLUGINNAME" = "Sms" ] || [ "$PLUGINNAME" = "SMS" ] ; then
    echo "Plugin "sms" selected to add in "$DEST" " | log
    $GITPATH/sms $SVNCMD  2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "aws" ] || [ "$PLUGINNAME" = "Aws" ] || [ "$PLUGINNAME" = "AWS" ] ; then
    echo "Plugin "aws" selected to add in "$DEST" " | log
    $GITPATH/aws $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "appsensors" ] || [ "$PLUGINNAME" = "Appsensors" ] || [ "$PLUGINNAME" = "APPSENSORS" ]; then
    echo "Plugin "appsensors" selected to add in "$DEST" " | log
    $GITPATH/appsensors $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "expiry" ] || [ "$PLUGINNAME" = "Expiry" ] || [ "$PLUGINNAME" = "EXPIRY" ]; then
    echo "Plugin "expiry" selected to add in "$DEST" " | log
    $GITPATH/expiry $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "backup" ] || [ "$PLUGINNAME" = "Backup" ] || [ "$PLUGINNAME" = "BACKUP" ]; then
    echo "Plugin "backup" selected to add in "$DEST" " | log
    $GITPATH/backup $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "dns" ] || [ "$PLUGINNAME" = "DNS" ] || [ "$PLUGINNAME" = "dns" ]; then
    echo "Plugin "dns" selected to add in "$DEST" " | log
    $GITPATH/dns $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "docker" ] || [ "$PLUGINNAME" = "Docker" ] || [ "$PLUGINNAME" = "DOCKER" ]; then
    echo "Plugin "docker" selected to add in "$DEST" " | log
    $GITPATH/docker $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME successfully added. " | log


elif [ "$PLUGINNAME" = "hardware" ] || [ "$PLUGINNAME" = "Hardware" ] || [ "$PLUGINNAME" = "HARDWARE" ]; then
    echo "Plugin "hardware" selected to add in "$DEST" " | log
    $GITPATH/hardware $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "lamp" ] || [ "$PLUGINNAME" = "Lamp" ] || [ "$PLUGINNAME" = "LAMP" ]; then
    echo "Plugin "lamp" selected to add in "$DEST" " | log
    $GITPATH/lamp $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "mithi" ] || [ "$PLUGINNAME" = "Mithi" ] || [ "$PLUGINNAME" = "MITHI" ]; then
    echo "Plugin "mithi" selected to add in "$DEST" " | log
    $GITPATH/mithi $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "os" ] || [ "$PLUGINNAME" = "Os" ] || [ "$PLUGINNAME" = "OS" ]; then
    echo "Plugin "os" selected to add in "$DEST" " | log
    $GITPATH/os $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "jvm" ] || [ "$PLUGINNAME" = "Jvm" ] || [ "$PLUGINNAME" = "JVM" ]; then
    echo "Plugin "jvm" selected to add in "$DEST" " | log
    $GITPATH/jvm $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log


elif [ "$PLUGINNAME" = "website" ] || [ "$PLUGINNAME" = "Website" ] || [ "$PLUGINNAME" = "WEBSITE" ]; then
    echo "Plugin "website" selected to add in "$DEST" " | log
    $GITPATH/website $SVNCMD  2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
        rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log

elif [ "$PLUGINNAME" = "node" ] || [ "$PLUGINNAME" = "Node" ] || [ "$PLUGINNAME" = "NODE" ]; then
    echo "Plugin "node" selected to add in "$DEST" " | log
    $GITPATH/node $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log

elif [ "$PLUGINNAME" = "jenkins" ] || [ "$PLUGINNAME" = "Jenkins" ] || [ "$PLUGINNAME" = "JENKINS" ]; then
    echo "Plugin "jenkins" selected to add in "$DEST" " | log
    $GITPATH/jenkins $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log

elif [ "$PLUGINNAME" = "ELK" ] || [ "$PLUGINNAME" = "Elk" ] || [ "$PLUGINNAME" = "elk" ]; then
    echo "Plugin "elk" selected to add in "$DEST" " | log
    $GITPATH/elk $SVNCMD 2>/dev/null || { echo "Incorrect git credentials, Exiting now..." | log ; exit 1; }
    rm -rf $DEST/.svn
    echo "$PLUGINNAME plugin successfully added. " | log

else
    echo "#######################################################" | log 
    echo "Invalid $PLUGINNAME. Enter valid plugin name. Exiting now..!" | log 
    exit 3;
fi

}

# To disable svn password cache storing
#######################################################

disable_svn_password () {

echo "#######################################################" | log
echo "Disabling svn password store" | log
sudo echo 'store-plaintext-passwords = no' >> /root/.subversion/servers
}


# Function calling
#######################################################

while true
do
        user_input
        copy_plugin
        disable_svn_password

break
done

# End Main logic.
#######################################################

