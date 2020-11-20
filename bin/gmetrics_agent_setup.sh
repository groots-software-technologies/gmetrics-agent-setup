#!/bin/sh
#######################################################
# Program: Gmetrics remote side plugin installation.
#
# Purpose:
#  This script installing gmetrics-remote plugin on the remote system,
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

# Verify root privileges User.
#######################################################

check_user() {

LOGGEDUSER=$(whoami)
if [ $LOGGEDUSER != root ]
then
        echo "#######################################################" | log
        echo 'You are not authorized to run this script, this script required "root" user or equivalent privileges.' | log
        echo "#######################################################" | log
        exit 3;
fi

}

# Main Logic.
#######################################################
REMOTEPACKAGE_RHEL_CENTOS="gmetrics-remote-el7-v4.3.2.2020.tar.gz"
REMOTEPACKAGE_UBUNTU="gmetrics-remote-deb-v4.3.2.2020.tar.gz"
GRPEPATH="/root/gmetricsdata/gmetrics-agent-setup/"
CURRENTPATH=`pwd`

# Finding installed operating system details.
#######################################################

gmetrics_remote_os_details () {

echo "#######################################################" | log
echo "Finding installed operating system details" | log
OSNAME=$(cat /etc/*release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
echo "Installed operating system : $OSNAME" | log
OS_VERSION=$(cat /etc/*release | grep "VERSION_ID" | sed 's/VERSION_ID=//g' |sed 's/["]//g' | awk '{print $1}' | cut -d. -f1)
echo "OS Version is : $OS_VERSION" | log
}

# Gmetrics remote user addition.
#######################################################

gmetrics_remote_user_addition () {
id groots
RET=`echo $?`
if [ $RET != 0 ]
then
	echo "#######################################################" | log
	echo "Gmetrics remote user adding and ownership updating." | log
	echo "useradd groots" | log
	useradd groots
else
	echo "#######################################################" | log
	echo "Gmetrics remote user is present, please remove user and home directory."
	exit 3
fi

}

# Gmetrics remote plugin directory creation.
#######################################################

gmetrics_remote_plugin_directory_addition () {

echo "#######################################################" | log
echo "Gmetrics plugin directory creating." | log
PLUGINSDIR="/groots/tmp/"
mkdir -p $PLUGINSDIR
echo "Gmetrics plugin \"$PLUGINSDIR\" directory successfully created" | log
}

# Verify /groots directory ownership permission
######################################################

verify_groots_dir_permission () {

echo "#######################################################" | log
echo "Verifying Permission and ownership of "/groots" directory " | log 
DIRPERMISSION=$(stat -c '%a' /groots)
USEROWNERSHIP=$(ls -ld /groots | awk '{print $3}')
GROUPOWNERSHIP=$(ls -ld /groots | awk '{print $4}')

if [ "$DIRPERMISSION" = "755" ] && [ "$USEROWNERSHIP" = "root" ] && [ "$GROUPOWNERSHIP" = "root" ] 
then
	echo "########################################################" | log
	echo "Permission verified for /groots directory
	      Directory permission for "/groots/" is set - $DIRPERMISSION
	      Directory userownership for  "/groots/" is set - $USEROWNERSHIP
	      Directory groupownership for  "/groots/" is set - $GROUPOWNERSHIP " | log 
else
	echo "########################################################" | log
	echo "Permission verification failed for /groots direcrtory" | log 
	echo "Directory permission for "/groots" is set - $DIRPERMISSION
	      Directory ownsership for "/groots" is set - $USEROWNERSHIP
	      Directory groupownership for  "/groots" is set - $GROUPOWNERSHIP" | log 
	exit 3
fi
}

# Get ip address from system.
#######################################################

gmetrics_remote_getipaddress () {

echo "#######################################################" | log
echo "IP address gathering from system" | log
IPADDRESS="$(hostname -I | awk '{print $1}')"
echo "System IP address is : $IPADDRESS" | log
}

# Changing permissions of file /bin/ping and /bin/ping6
#######################################################

gmetrics_remote_change_ping_permission (){

echo "#######################################################" | log
echo "Verify ping command permissions" | log
ls -ltrh /bin/ping | log
ls -ltrh /bin/ping6 | log
echo "#######################################################" | log
echo "Changing permissions of file /bin/ping and /bin/ping6" | log
chmod u+s /bin/ping | log
chmod u+s /bin/ping6 | log
}

# CentOS-7 gmetrics-remote plugin download.
#######################################################

gmetrics_remote_centos7_plugins () {

echo "#######################################################" | log
echo "Downloading gmetrics-remote plugin on the system." | log
cp -avp $GRPEPATH/$REMOTEPACKAGE_RHEL_CENTOS $PLUGINSDIR/ | log
echo "Gmetrics remote plugin is successfully downloaded under \"$PLUGINSDIR\"" | log
echo "Verify downloaded gmetrics-remote plugin." | log
echo "#######################################################" | log
ls -ltrh $PLUGINSDIR | log

}

# Extracting gmetrics-remote tar file.
#######################################################

gmetrics_remote_centos7_untarzipfile () {

echo "#######################################################" | log
echo "Gmetrics remote plugin extracting." | log
tar -tvf $PLUGINSDIR/$REMOTEPACKAGE_RHEL_CENTOS | log
echo "#######################################################" | log
tar -pxvf $PLUGINSDIR/$REMOTEPACKAGE_RHEL_CENTOS -C /  | log
echo "#######################################################" | log
echo "Gmetrics plugin successfully extracted." | log
echo "#######################################################" | log
echo "Updating ownership of gmetrics-remote config directory"   | log
chown -R groots. /groots/metrics/  | log
echo "Verify gmetrics-remote plugin config directory ownership." | log
echo "#######################################################" | log
ls -ltrh /groots/metrics/ | log
}

# Ubuntu gmetrics-remote plugin download
#######################################################

gmetrics_remote_ubuntu_plugins () {

echo "#######################################################" | log
echo "Downloading gmetrics-remote plugin on the system." | log
cp -avp $GRPEPATH/$REMOTEPACKAGE_UBUNTU $PLUGINSDIR/ | log
echo "Gmetrics remote plugin is successfully downloaded under \"$PLUGINSDIR\"" | log
echo "Verify downloaded gmetrics-remote plugin." | log
echo "#######################################################" | log
ls -ltrh $PLUGINSDIR | log

}

# Extracting gmetrics-remote tar file.
#######################################################

gmetrics_remote_ubuntu_untarzipfile () {

echo "#######################################################" | log
echo "Gmetrics remote plugin extracting." | log
tar -tvf  $PLUGINSDIR/$REMOTEPACKAGE_UBUNTU | log
echo "#######################################################" | log
tar -pxvf $PLUGINSDIR/$REMOTEPACKAGE_UBUNTU -C / | log
echo "#######################################################" | log
echo "Gmetrics plugin successfully extracted." | log
echo "#######################################################" | log
echo "Updating ownership of gmetrics-remote config directory"   | log
chown -R groots. /groots/metrics/  | log
echo "Verify gmetrics-remote plugin config directory ownership." | log
echo "#######################################################" | log
ls -ltrh /groots/metrics/ | log
}

# Gmetrics remote port entry add in /etc/services file.
#######################################################

gmetrics_remote_service_port_entry () {

echo "#######################################################" | log
echo "Take backup of existing service config file." | log
cp -avp /etc/services /etc/services_$(date +"%d-%m-%YT%H-%M-%S") | log
sudo sh -c "echo >> /etc/services"
echo "Adding gmetrics-remote port 5666/tcp in /etc/services" | log
echo "gmetrics-remote 5666/tcp                # Gmetrics services" >> /etc/services
echo "Gmetrics remote service port successfully added in service config file." | log
cat /etc/services | egrep  "gmetrics-remote" | log

}

# Gmetrics remote user entry add in Sudoers File.
#######################################################

gmetrics_remote_sudoers_entry () {

echo "#######################################################" | log
echo "Gmetrics remote user entry add in sudoes file to execute plugin." | log
pkexec chmod 0440 /etc/sudoers | log
echo 'Defaults:groots    !requiretty' > /etc/sudoers.d/gmetrics-remote
echo "groots          ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/gmetrics-remote
echo "Gmetrics remote user entry successfully added in sudoers file." | log
cat /etc/sudoers.d/gmetrics-remote | log
}

# Adding remote server LAN IP in gmetrics-remote config file.
#######################################################

gmetrics_remote_assign_ipaddress () {

echo "#######################################################" | log
echo "Adding gmetrics-remote server lan ip address in config file."   | log
cp -avp /groots/metrics/config/gmetrics-agent.cfg /groots/metrics/config/gmetrics-agent.cfg_$(date +"%d-%m-%YT%H-%M-%S") | log
sudo sh -c "sed -i '/^allowed_hosts=/s/$/,${IPADDRESS}/' /groots/metrics/config/gmetrics-agent.cfg"
cat /groots/metrics/config/gmetrics-agent.cfg | egrep "allowed_hosts" | log
echo "Remote server LAN IP successfully added in gmetrics-agent config file." | log
}

# Adding gmetrics-remote port in firewall.
#######################################################

gmetrics_remote_firewall () {

echo "#######################################################" | log
echo "Adding gmetrics-remote port in firewall." | log

if [ "$OSNAME" = "CentOS" ] && [ "$OS_VERSION" = "7" ]; then
        SERVICETOOL="systemctl status firewalld | egrep -i 'Active'"
        STATUS_MSG=$(eval "$SERVICETOOL|tail -n 1" 2>&1)
        echo "Server firewall : $STATUS_MSG" | log
case $STATUS_MSG in

*stop*)
        STATUS="STOPPED"
        ;;
*Stopped*)
        STATUS="STOPPED"
        ;;
*not*running*)
        STATUS="STOPPED"
        ;;
*running*)
        STATUS="RUNNING"
        ;;
*Running*)
        STATUS="RUNNING"
        ;;
*SUCCESS*)
        STATUS="RUNNING"
        ;;
*[eE]rr*)
        STATUS="STOPPED"
        ;;
*[fF]ailed*)
        STATUS="STOPPED"
        ;;
*[eE]nable*)
        STATUS="RUNNING"
        ;;
*[dD]isable*)
        STATUS="STOPPED"
        ;;
*[cC]annot*)
        STATUS="STOPPED"
        ;;
*[iI]nactive*)
        STATUS="STOPPED"
        ;;
*[aA]ctive*)
        STATUS="RUNNING"
        ;;
esac
        if [ $STATUS = RUNNING ]
        then
                echo "Firewalld service is running. So adding gmetrics-remote port in firewall." | log
                firewall-cmd --permanent --add-port=5666/tcp | log
                firewall-cmd --reload | log
                firewall-cmd --list-all | log
        else
                echo "Firewalld service is not-running. So not added gmetrics-remote port in firewall." | log
        fi
elif [ "$OSNAME" = Ubuntu ]
then
        SERVICETOOL='ufw status | egrep -i "active"'
        STATUS_MSG=$(eval "$SERVICETOOL|tail -n 1" 2>&1)
        echo "Server firewall : $STATUS_MSG" | log
case $STATUS_MSG in

*stop*)
        STATUS="STOPPED"
        ;;
*Stopped*)
        STATUS="STOPPED"
        ;;
*not*running*)
        STATUS="STOPPED"
        ;;
*running*)
        STATUS="RUNNING"
        ;;
*Running*)
        STATUS="RUNNING"
        ;;
*SUCCESS*)
        STATUS="RUNNING"
        ;;
*[eE]rr*)
        STATUS="STOPPED"
        ;;
*[fF]ailed*)
        STATUS="STOPPED"
        ;;
*[eE]nable*)
        STATUS="RUNNING"
        ;;
*[dD]isable*)
        STATUS="STOPPED"
        ;;
*[cC]annot*)
        STATUS="STOPPED"
        ;;
*[iI]nactive*)
        STATUS="STOPPED"
        ;;
*[aA]ctive*)
        STATUS="RUNNING"
        ;;
esac
        if [ $STATUS = RUNNING ]
        then
                echo "Ubuntu firewall service is running. So adding gmetrics-remote port in ufw firewall." | log
                echo '[GMETRICS-REMOTE]' > /etc/ufw/applications.d/gmetrics-remote
                echo "title=Gmetrics Remote Plugin Executor." >> /etc/ufw/applications.d/gmetrics-remote
                echo "description=Allows gmetrics-remote to execution of gmetrics plugins." >> /etc/ufw/applications.d/gmetrics-remote
                echo "ports=5666/tcp" >> /etc/ufw/applications.d/gmetrics-remote
                cat /etc/ufw/applications.d/gmetrics-remote | log
        else
                echo "Ubuntu firewall service is not-running. So not added gmetrics-remote port in ufw firewall." | log
        fi
 fi
}

# Start gmetrics-remote services.
#######################################################

gmetrics_remote_service_start () {

echo "#######################################################" | log
echo "Starting gmetrics-agent service." | log
sudo systemctl daemon-reload | log
sudo systemctl enable gmetrics-agent | log
sudo systemctl start gmetrics-agent | log
sudo systemctl status gmetrics-agent | log
}

# Verify gmetrics-remote service status.
#######################################################

gmetrics_remote_connectivity_test () {

echo "#######################################################" | log
echo "Verifying gmetrics-remote service port status." | log
sudo netstat -pntl | egrep 5666 | log
echo "#######################################################" | log
echo "Check gmetrics-remote installed version." | log
echo 'sudo /groots/metrics/libexec/check_metrics -H 127.0.0.1' | log
sudo /groots/metrics/libexec/check_metrics -H 127.0.0.1 | log
echo "#######################################################" | log
echo "Check gmetrics-remote command with arguments." | log
echo "sudo /groots/metrics/libexec/check_metrics -H $IPADDRESS -c check_users -a '-w 5 -c 8'" | log
sudo /groots/metrics/libexec/check_metrics -H $IPADDRESS -c check_users -a "-w 5 -c 8" | log
echo "#######################################################" | log
echo "Gmetrics remote service is successfully started." | log
}

# Main Functions Calling.
#######################################################

# Gmetrics Remote functions calling according to OSNAME.
#######################################################

# Checking current user
#######################################################
check_user

# Finding installed operating system details.
#######################################################
gmetrics_remote_os_details

if [ "$OSNAME" = "CentOS" ] && [ "$OS_VERSION" = "7" ]; then
        echo "#######################################################" | log
        echo "Gmetrics remote installtion starting at [`date`]." | log
        echo "#######################################################" | log
        echo "Verifying if following packages are present or not." | log
        echo "sysstat gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel bind-utils net-snmp-devel net-snmp-utils net-snmp-perl" | tr ' ' '\n' | while read line; do rpm -qa -last | grep -i $line; done | log
        echo "openssl" | tr ' ' '\n'  | while read line; do rpm -qa -last | grep -i $line; done | log
        echo "#######################################################" | log
        echo "Installing gmetrics required packages." | log
        echo "You need to install these os libraries packages on the server : sysstat telnet net-tools wget make bind-utils openssl openssl-devel mod_ssl lsof bc" | log

        # Gmetrics remote user addition.
        gmetrics_remote_user_addition

        # Gmetrics remote plugin directory creation.
        gmetrics_remote_plugin_directory_addition
	
	# Verify permission for /groots directory
	verify_groots_dir_permission

        # Get ip address from system.
        gmetrics_remote_getipaddress

        # Changing permissions of file /bin/ping and /bin/ping6
        gmetrics_remote_change_ping_permission

        # CentOS-7 gmetrics-remote plugin download.
        gmetrics_remote_centos7_plugins

        # Extracting gmetrics-remote tar file.
        gmetrics_remote_centos7_untarzipfile

        # Gmetrics remote port entry add in /etc/services file.
        gmetrics_remote_service_port_entry

        # Gmetrics remote user entry add in Sudoers File.
        gmetrics_remote_sudoers_entry

        # Adding remote server LAN IP in gmetrics-agent config file.
        gmetrics_remote_assign_ipaddress

        # Adding gmetrics-remote port in firewall.
        gmetrics_remote_firewall

        # Start gmetrics-remote services.
        gmetrics_remote_service_start

        # Verify gmetrics-remote service status.
        gmetrics_remote_connectivity_test

        echo "#######################################################" | log

elif [ "$OSNAME" = "Ubuntu" ]; then
        echo "#######################################################" | log
        echo "Gmetrics remote installtion starting at [`date`]." | log
        echo "#######################################################" | log
        echo "Verifying if following packages are present or not." | log
        sudo echo "automake openssl sysstat autoconf gcc libc6 libmcrypt-dev make libssl-dev wget bc gawk dc build-essential snmp libnet-snmp-perl gettext" | tr ' ' '\n'  | while read line; do apt list --installed | egrep -o $line; done 2> /dev/null
        echo "#######################################################" | log
        echo "Installing gmetrics required packages." | log
        echo "You need to install these os libraries packages on the server : telnet libgd-dev libmcrypt-dev libssl-dev dc snmp libnet-snmp-perl sysstat openssl vim dos2unix git" | log

        # Gmetrics remote user addition.
        gmetrics_remote_user_addition

        # Gmetrics remote plugin directory creation.
        gmetrics_remote_plugin_directory_addition

        # Verify permission for /groots directory
	verify_groots_dir_permission

        # Get ip address from system.
        gmetrics_remote_getipaddress

        # Changing permissions of file /bin/ping and /bin/ping6
        gmetrics_remote_change_ping_permission

        # Ubuntu gmetrics-remote plugin download.
        gmetrics_remote_ubuntu_plugins

        # Extracting gmetrics-remote tar file.
        gmetrics_remote_ubuntu_untarzipfile

        # Gmetrics remote port entry add in /etc/services file.
        gmetrics_remote_service_port_entry

        # Gmetrics remote user entry add in Sudoers File.
        gmetrics_remote_sudoers_entry

        # Adding remote server LAN IP in gmetrics-agent config file.
        gmetrics_remote_assign_ipaddress

        # Adding gmetrics-remote port in firewall.
        gmetrics_remote_firewall

        # Start gmetrics-remote services.
        gmetrics_remote_service_start

        # Verify gmetrics-remote service status.
        gmetrics_remote_connectivity_test

        echo "#######################################################" | log
fi

echo "Gmetrics remote side plugin executor is successfully installed." | log
echo "Gmetrics Installation is completed at [`date`]." | log

echo "
NOTE : If gmetrics-remote service does not started then check installation log file [$LOGFILE]
       And gmetrics-remote service log file [/groots/metrics/var/gmetrics-agent.log]
       Or your system log file.
" | log

# End Main Logic.
#######################################################
