#!/bin/bash
#######################################################
# Program: Gmetrics Agent setup uninstallation.
#
# Purpose:
#  This script uninstalls gmetrics-agent on the remote system,
#  can be run in interactive.
#
# License:
#  This program is distributed in the hope that it will be useful,
#  but under groots software technologies @rights.
#
#######################################################

# Check for people who need help - aren't we all nice ;-)
#######################################################

# Set script name
#######################################################

SCRIPTNAME="gmetrics_agent_uninstall.sh"

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

# Main function
#######################################################

# To disable gmetrics-agent service and daemon-reload
#######################################################

disable_service () {

if [ -f /lib/systemd/system/gmetrics-agent.service ]
then
	echo "#################################################" | log
	echo "Disabling gmetrics-agent service" | log
	sudo systemctl disable gmetrics-agent | log
	echo "#################################################" | log
	echo "Stopping gmetrics-agent service" | log
	sudo systemctl stop gmetrics-agent | log
	echo "#################################################" | log
	echo "Removing gmetrics-agent service" | log
	rm -rvf /lib/systemd/system/gmetrics-agent.service | log
	echo "#################################################" | log
	echo "Reload systemd daemon to apply changes" | log
	sudo systemctl daemon-reload | log
else
	echo "gmetrics-agent.service is not found." | log 
fi
}

# To remove /etc/logrotate.d/gmetrics-agent logrotate file
#######################################################

remove_logrotate () {

if [ -f /etc/logrotate.d/gmetrics-agent ]
then
	echo "#################################################" | log
	echo "Removing logrotate file" | log
	sudo rm -rvf /etc/logrotate.d/gmetrics-agent | log
else
	echo "#################################################" | log
	echo "gmetrics-agent logrotate file not found." | log
fi
}

# To remove port from /etc/services
#######################################################

remove_service_port () {

echo "#################################################" | log
echo "Take backup of service file" | log
cp -avp /etc/services /etc/services_$(date +"%d-%m-%YT%H-%M-%S") | log
echo "#################################################" | log
echo "Remove gmetrics-agent port from Service file" | log
sed -i '/gmetrics-agent 5666\/tcp # Gmetrics services/d' /etc/services | log
}


# To remove groots & empty tmp directory
#######################################################

remove_groots_directory () {

echo "#################################################" | log
echo "Cleaning temporary files and directory from \"/groots/tmp/\"" | log
rm -rvf /groots/tmp/* | log
rm -rvf /groots/tmp/.svn/ | log

if [ -d /groots/metrics  ]
then
	echo "#################################################" | log
	echo "Removing gmetrics-agent config directory" | log
	rm -rvf /groots/metrics | log
	echo "#################################################" | log
	echo "gmetrics-agent directory successfully cleaned." | log
else
	echo "#################################################" | log
	echo "gmetrics-agent config directory not found." | log
fi

}

# To remove groots user and home directory
#######################################################

remove_user () {

echo "#################################################" | log
echo "Removing groots user" | log
getent passwd groots   > /dev/null

if [ `echo $?` -eq 0 ]
then
	echo "#################################################" | log
	echo "Removing gmetrics-agent user home directory" | log
	userdel -r groots > /dev/null
else
	echo "#################################################" | log
	echo "gmetrics-agent user home directory not found." | log
fi
}

# To remove firewall port for gmetrics-agent
#######################################################

remove_firewall_entry () {

OSNAME=$(cat /etc/*release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')

if [ $OSNAME == "Ubuntu" ]; then
        echo "#################################################" | log
        echo "Removing gmetrics-agent ufw entry" | log
        rm -rvf /etc/ufw/applications.d/gmetrics-agent | log
elif [  $OSNAME == "CentOS" ]; then
        echo "#################################################" | log
        echo "Removing gmetrics-agent port from firewall" | log
        firewall-cmd --permanent --remove-port=5666/tcp | log
        firewall-cmd --reload | log
        firewall-cmd --list-all | log
        echo "#################################################" | log
        echo "gmetrics-agent port successfully removed" | log
fi

}


# To remove sudoers-entry for gmetrics-agent
#######################################################

remove_sudoers_entry () {

if [ -f /etc/sudoers.d/gmetrics-agent ]
then
	echo "#################################################" | log
	echo "Removing gmetrics-agent user entry from sudoers file." | log
	rm -rvf /etc/sudoers.d/gmetrics-agent | log
else
	echo "#################################################" | log
	echo "gmetrics-agent user entry not found in sudoers file." | log
fi
}

# Function calling
#######################################################

while true
do
        echo "#######################################################" | log
        echo "Gmetrics agent cleanup process started at [`date`]." | log

        disable_service
        remove_firewall_entry
        remove_logrotate
        remove_service_port
        remove_user
        remove_sudoers_entry
        remove_groots_directory

if [ `echo $?` = 0 ]
then
        echo "#######################################################" | log
        echo "Gmetrics Agent is successfully uninstalled." | log
        echo "Gmetrics Agent cleanup process completed at [`date`].
	      Please Refer logfile [$LOGFILE] for more info." | log
        echo "#######################################################" | log
else
        echo "#######################################################" | log
        echo "Gmetrics Agent is [FAILED] to uninstalled.
	      Please Refer logfile [$LOGFILE] for more info." | log
        echo "#######################################################" | log
fi
break
done

# End Main Logic.
#######################################################


