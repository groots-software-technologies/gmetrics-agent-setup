#!/bin/bash
#######################################################
# Program: Gmetrics monitoring plugins listing.
#
# Purpose:
#  Check server health and process using gmetrics plugins.
#  can be run in interactive.
#
# License:
#  This program is distributed in the hope that it will be useful,
#  but under groots software technologies @rights.
#
# Author: Groots Metrics Team
# Email : support@groots.in
#######################################################

# Check for people who need help - aren't we all nice ;-)
#######################################################

# Set script name
#######################################################
SCRIPTNAME="gmetrics_agent_setup.sh"

# type command is checking whether svn, sar command present or not.
#######################################################
type svn >/dev/null 2>&1 || { echo >&2 "This plugin require \"subversion\" package, but it's not installed. Aborting."; }
type sar >/dev/null 2>&1 || { echo >&2 "This plugin require \"sysstat\" package, but it's not installed. Aborting.";  }
type netstat >/dev/null 2>&1 || { echo >&2 "This plugin require \"net-tools\" package, but it's not installed. Aborting.";  }
type dig >/dev/null 2>&1 || { echo >&2 "This plugin require \"bind-utils\" package for RHEL/CentOs/SUSE/Amazon Linux and \"dnsutils\" for Ubunutu, but it's not installed. Aborting."; }

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

REMOTEPACKAGE_RHEL_CENTOS="gmetrics-agent-el7-V5.02.12.2020.tar.gz"
REMOTEPACKAGE_UBUNTU="gmetrics-agent-deb-V5.27.11.2020.tar.gz"
REMOTEPACKAGE_RHEL_CENTOS8="gmetrics-agent-el8-V5.30.11.2020.tar.gz"
REMOTEPACKAGE_AMAZONLINUX="gmetrics-agent-al2-V5.15.01.2021.tar.gz"
REMOTEPACKAGE_SUSE="gmetrics-agent-suse12-V5.14.05.2021.tar.gz"

# Finding installed operating system details.
#######################################################

gmetrics_agent_os_details () {

echo "#######################################################" | log
echo "Finding installed operating system details" | log
OSNAME=$(cat /etc/*release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' | awk '{print $1}')
echo "Installed operating system : $OSNAME" | log
OS_VERSION=$(cat /etc/*release | grep "VERSION_ID" | sed 's/VERSION_ID=//g' |sed 's/["]//g' | awk '{print $1}' | cut -d. -f1)
echo "OS Version is : $OS_VERSION" | log
}

# Check Selinux status - to be in disabled mode 
#######################################################

verify_selinux () {

echo "#######################################################" | log 
echo "Verifying status of Selinux.." | log 

SELINUX_STATUS=`getenforce`

if [ "$SELINUX_STATUS" == "Enforcing" ]; then
        echo "#######################################################" | log 
        echo "WARNING! Selinux is in enforcing mode!!" | log 
        echo "#######################################################" | log 
fi

}

# Gmetrics agent user addition.
#######################################################

gmetrics_agent_user_addition () {
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

# Gmetrics agent plugin directory creation.
#######################################################

gmetrics_agent_plugin_directory_addition () {

echo "#######################################################" | log
echo "Disabling password store for subversion" | log
sudo echo 'store-plaintext-passwords = no' >> /root/.subversion/servers | log
echo "#######################################################" | log
echo "Gmetrics plugin directory creating." | log
PLUGINSDIR="/groots/tmp/"
mkdir -p $PLUGINSDIR
echo "Gmetrics plugin \"$PLUGINSDIR\" directory successfully created" | log

echo "#######################################################" | log
echo "Downloading Agent builds under $PLUGINSDIR directory" | log
URL="https://github.com/grootsadmin/gmetrics-agent-setup/branches/alpha/v5/builds"
svn checkout $URL $PLUGINSDIR > /dev/null &  PID=$!
echo "THIS PROCESS TAKES SOME TIME, SO PLEASE BE PATIENCE WHILE GMETRICS AGENT INSTALLATION IS RUNNING..." | log
printf "["
while kill -0 $PID 2> /dev/null; do
    printf  "....++...."
    sleep 1
done
printf "]"
printf "Downloading completed. \n" | log
ls $PLUGINSDIR*.gz  > /dev/null 2>&1  || { echo "Gmetrics Remote Agent For Linux is not installed." | log ; exit 3; }
echo "#######################################################" | log
echo "Downloading builds under $PLUGINSDIR directory completed!!!" | log
}

# Verify /groots directory ownership permission
######################################################

verify_groots_dir_permission () {

echo "#######################################################" | log
echo "Verifying Permission and ownership of "/groots" directory " | log 
echo "#######################################################" | log

if [ `stat -c "%a" /groots` = 755 ]; then
	echo "Directory permission for "/groots" is 755 " | log
else
	echo "Changing directory permission to 755 for "/groots"" | log
	chmod 755 /groots
fi

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

gmetrics_agent_getipaddress () {

echo "#######################################################" | log
echo "IP address gathering from system" | log
IPADDRESS=`ip route get 1.2.3.4 | awk '{print $7}' | head -n1`
echo "System IP address is : $IPADDRESS" | log
}

# Changing permissions of file /bin/ping and /bin/ping6
#######################################################

gmetrics_agent_change_ping_permission (){

echo "#######################################################" | log
echo "Verify ping command permissions" | log
ls -ltrh /bin/ping | log
ls -ltrh /bin/ping6 | log
echo "#######################################################" | log
echo "Changing permissions of file /bin/ping and /bin/ping6" | log
chmod u+s /bin/ping | log
chmod u+s /bin/ping6 | log
}

# Verify log path permission
######################################################

verify_log_path_permission () {

echo "#######################################################" | log
echo "Verifying Permission and ownership of "/var/log/groots/gmetrics" directory " | log

LOGUSEROWNERSHIP=$(ls -ld /var/log/groots/gmetrics | awk '{print $3}')
LOGGROUPOWNERSHIP=$(ls -ld /var/log/groots/gmetrics | awk '{print $4}')

if  [ "$LOGUSEROWNERSHIP" = "groots" ] && [ "$LOGGROUPOWNERSHIP" = "groots" ]
then
        echo "########################################################" | log
        echo "Permission verified for /var/log/groots/gmetrics directory is groots" | log
else
        chown -R groots. /var/log/groots/gmetrics/
        echo "########################################################" | log
        echo "Ownership for /var/log/groots/gmetrics/ is changed to groots" | log
fi
}

# Extracting gmetrics-remote tar file.
#######################################################

gmetrics_agent_centos7_untarzipfile () {

echo "#######################################################" | log
echo "Gmetrics agent tarball extracting for $OSNAME" | log
tar -tvf $PLUGINSDIR/$REMOTEPACKAGE_RHEL_CENTOS | log
echo "#######################################################" | log
tar -pxvf $PLUGINSDIR/$REMOTEPACKAGE_RHEL_CENTOS -C /  | log
echo "#######################################################" | log
echo "Gmetrics build successfully extracted." | log
echo "#######################################################" | log
echo "Updating ownership of gmetrics-agent config directory"   | log
chown -R groots. /groots/metrics/  | log
echo "Verify gmetrics-agent config directory ownership." | log
echo "#######################################################" | log
ls -ltrh /groots/metrics/ | log
}

# Extracting Amazon linux tar
#######################################################

gmetrics_agent_amazon_linux_untarzipfile () {

echo "#######################################################" | log
echo "Gmetrics agent tarball extracting for $OSNAME linux" | log
tar -tvf $PLUGINSDIR/$REMOTEPACKAGE_AMAZONLINUX | log
echo "#######################################################" | log
tar -pxvf $PLUGINSDIR/$REMOTEPACKAGE_AMAZONLINUX -C /  | log
echo "#######################################################" | log
echo "Gmetrics build successfully extracted." | log
echo "#######################################################" | log
echo "Updating ownership of gmetrics-agent config directory"   | log
chown -R groots. /groots/metrics/  | log
echo "Verify gmetrics-agent config directory ownership." | log
echo "#######################################################" | log
ls -ltrh /groots/metrics/ | log
}

# Extracting gmetrics-remote tar file.
#######################################################

gmetrics_agent_centos8_untarzipfile () {

echo "#######################################################" | log
echo "Gmetrics agent tarball extracting for $OSNAME" | log
tar -tvf $PLUGINSDIR/$REMOTEPACKAGE_RHEL_CENTOS8 | log
echo "#######################################################" | log
tar -pxvf $PLUGINSDIR/$REMOTEPACKAGE_RHEL_CENTOS8 -C /  | log
echo "#######################################################" | log
echo "Gmetrics build successfully extracted." | log
echo "#######################################################" | log
echo "Updating ownership of gmetrics-agent config directory"   | log
chown -R groots. /groots/metrics/  | log
echo "Verify gmetrics-agent config directory ownership." | log
echo "#######################################################" | log
ls -ltrh /groots/metrics/ | log
}


# Extracting gmetrics-agent tar file.
#######################################################

gmetrics_agent_ubuntu_untarzipfile () {

echo "#######################################################" | log
echo "Gmetrics agent tarball extracting." | log
tar -tvf  $PLUGINSDIR/$REMOTEPACKAGE_UBUNTU | log
echo "#######################################################" | log
tar -pxvf $PLUGINSDIR/$REMOTEPACKAGE_UBUNTU -C / | log
echo "#######################################################" | log
echo "Gmetrics build successfully extracted." | log
echo "#######################################################" | log
echo "Updating ownership of gmetrics-agent config directory"   | log
chown -R groots. /groots/metrics/  | log
echo "Verify gmetrics-agent plugin config directory ownership." | log
echo "#######################################################" | log
ls -ltrh /groots/metrics/ | log
}

# Extracting gmetrics-agent tar file.
#######################################################

gmetrics_agent_suse_untarzipfile () {

echo "#######################################################" | log
echo "Gmetrics agent tarball extracting." | log
tar -tvf  $PLUGINSDIR/$REMOTEPACKAGE_SUSE | log
echo "#######################################################" | log
tar -pxvf $PLUGINSDIR/$REMOTEPACKAGE_SUSE -C / | log
echo "#######################################################" | log
echo "Gmetrics build successfully extracted." | log
echo "#######################################################" | log
echo "Updating ownership of gmetrics-agent config directory"   | log
chown -R groots. /groots/metrics/  | log
echo "Verify gmetrics-agent plugin config directory ownership." | log
echo "#######################################################" | log
ls -ltrh /groots/metrics/ | log
}

# Gmetrics agent port entry add in /etc/services file.
#######################################################

gmetrics_agent_service_port_entry () {

echo "#######################################################" | log
echo "Take backup of existing service config file." | log
cp -avp /etc/services /etc/services_$(date +"%d-%m-%YT%H-%M-%S") | log
sudo sh -c "echo >> /etc/services"
echo "Adding gmetrics-agent port 5666/tcp in /etc/services" | log
echo "gmetrics-agent 5666/tcp                # Gmetrics services" >> /etc/services
echo "Gmetrics agent service port successfully added in service config file." | log
cat /etc/services | egrep  "gmetrics-agent" | log

}

# Gmetrics agent user entry add in Sudoers File.
#######################################################

gmetrics_agent_sudoers_entry () {

echo "#######################################################" | log
echo "Gmetrics agent user entry add in sudoes file to execute plugin." | log
type pkexec > /dev/null 2>&1 && { pkexec chmod 0440 /etc/sudoers | log;} || sudo chmod 0440 /etc/sudoers 
echo 'Defaults:groots    !requiretty' > /etc/sudoers.d/gmetrics-agent
echo "groots          ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/gmetrics-agent
echo "Gmetrics agent user entry successfully added in sudoers file." | log
cat /etc/sudoers.d/gmetrics-agent | log
}

# Adding agent server LAN IP in gmetrics-remote config file.
#######################################################

gmetrics_agent_assign_ipaddress () {

echo "#######################################################" | log
echo "Adding gmetrics-agent server lan ip address in config file."   | log
cp -avp /groots/metrics/config/gmetrics-agent.cfg /groots/metrics/config/gmetrics-agent.cfg_$(date +"%d-%m-%YT%H-%M-%S") | log
sudo sh -c "sed -i '/^allowed_hosts=/s/$/,${IPADDRESS}/' /groots/metrics/config/gmetrics-agent.cfg"
cat /groots/metrics/config/gmetrics-agent.cfg | egrep "allowed_hosts" | log
echo "Remote server LAN IP successfully added in gmetrics-agent config file." | log
}

# Adding gmetrics-agent port in firewall.
#######################################################

gmetrics_agent_firewall () {

echo "#######################################################" | log
echo "Adding gmetrics-agent port in firewall." | log

if [ "$OSNAME" = "CentOS" ] && [ "$OS_VERSION" = "7" ] || [ "$OS_VERSION" = "8" ]; then
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
                echo "Firewalld service is running. So adding gmetrics-agent port in firewall." | log
                firewall-cmd --permanent --add-port=5666/tcp | log
                firewall-cmd --reload | log
                firewall-cmd --list-all | log
        else
                echo "Firewalld service is not-running. So not added gmetrics-agent port in firewall." | log
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
                echo "Ubuntu firewall service is running. So adding gmetrics-agent port in ufw firewall." | log
                echo '[GMETRICS]' > /etc/ufw/applications.d/gmetrics-agent
                echo "title=Gmetrics Agent Plugin Executor." >> /etc/ufw/applications.d/gmetrics-agent
                echo "description=Allows gmetrics-agent to execution of gmetrics plugins." >> /etc/ufw/applications.d/gmetrics-agent
                echo "ports=5666/tcp" >> /etc/ufw/applications.d/gmetrics-agent
                cat /etc/ufw/applications.d/gmetrics-agent | log
        else
                echo "Ubuntu firewall service is not-running. So not added gmetrics-agent port in ufw firewall." | log
        fi
 fi
}

# Start gmetrics-agent services.
#######################################################

gmetrics_agent_service_start () {

echo "#######################################################" | log
echo "Starting gmetrics-agent service." | log
sudo systemctl daemon-reload | log
sudo systemctl enable gmetrics-agent | log
sudo systemctl start gmetrics-agent | log
sudo systemctl status gmetrics-agent | log
}

# Verify gmetrics-agent service status.
#######################################################

gmetrics_agent_connectivity_test () {

echo "#######################################################" | log
echo "Verifying gmetrics-agent service port status." | log
sudo netstat -pntl | egrep 5666 | log
echo "#######################################################" | log
echo "Check gmetrics-agent installed version." | log
echo 'sudo /groots/metrics/libexec/check_metrics -H 127.0.0.1' | log
sudo /groots/metrics/libexec/check_metrics -H 127.0.0.1 | log
echo "#######################################################" | log
echo "Check gmetrics-agent command with arguments." | log
echo "sudo /groots/metrics/libexec/check_metrics -H $IPADDRESS -c check_users -a '-w 5 -c 8'" | log
sudo /groots/metrics/libexec/check_metrics -H $IPADDRESS -c check_users -a "-w 5 -c 8" | log
echo "#######################################################" | log
echo "Gmetrics agent service is successfully started." | log
}

# Main Functions Calling.
#######################################################

# Gmetrics Agent functions calling according to OSNAME.
#######################################################

# Checking current user
#######################################################
check_user

# Finding installed operating system details.
#######################################################
gmetrics_agent_os_details

if [ "$OSNAME" = "CentOS" ] && [ "$OS_VERSION" = "7" ] || [ "$OS_VERSION" = "8" ] || [ "$OSNAME" = "Amazon" ] || [ "$OSNAME" = "SUSE" ]; then

		echo "#######################################################" | log
		echo "Gmetrics agent installtion starting at [`date`]." | log
		echo "#######################################################" | log
		echo "Packages installation requires Internet connection. " | log 
		

        if [ "$OSNAME" = "CentOS" ] && [ "$OS_VERSION" = "7" ] || [ "$OSNAME" = "Amazon" ]; then
                echo "#######################################################" | log
                echo "Verifying if following packages are present or not for $OSNAME linux." | log
                echo "sysstat gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel bind-utils net-snmp-devel net-snmp-utils net-snmp-perl" | tr ' ' '\n' | while read line; do rpm -qa -last | grep -i $line; done | log
                echo "openssl" | tr ' ' '\n'  | while read line; do rpm -qa -last | grep -i $line; done | log
                echo "#######################################################" | log
                echo "Checking Installed gmetrics required packages." | log
                echo "You need to install these os libraries packages on the server : sysstat telnet net-tools wget make bind-utils openssl openssl-devel mod_ssl lsof bc" | log
		echo "#######################################################" | log
		yum install -y sysstat net-tools bind-utils gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel bind-utils net-snmp-devel net-snmp-utils net-snmp-perl subversion git 

        fi

        if [ "$OSNAME" = "CentOS" ] && [ "$OS_VERSION" = "8" ]; then
                echo "#######################################################" | log
                echo "Verifying if following packages are present or not for Centos8.." | log
                echo "Agent requires following packages on server: tcp_wrappers-libs-6.6-96.el8.x86_64.rpm compat-openssl10 libnsl.so.1 net-snmp-perl gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release epel" | log
		echo "#######################################################" | log
		echo "Installing required packages for Centos 8 " | log 
		yum install -y sysstat gcc net-tools glibc glibc-common gd gd-devel make net-snmp openssl-devel bind-utils net-snmp-devel net-snmp-utils net-snmp-perl git subversion  
		yum install compat-openssl10 libnsl.so.1 -y 
		yum install https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/t/tcp_wrappers-libs-7.6-96.el8.x86_64.rpm -y  
		list=("tcp_wrappers-libs-7.6-96.el8.x86_64" "compat-openssl10" "libnsl" "net-snmp-perl" "gcc" "glibc" "glibc-common" "make" "gettext" "automake" "autoconf" "wget" "openssl-devel" "net-snmp" "net-snmp-utils" "epel-release epel")
		for package in ${list[@]}; 
		do
			rpm -qa -last | grep -i $package || { echo >&2 "ERROR: $package package is not installed. Please install required packages!" | log ; }
		done

	fi

	if [ "$OSNAME" = "SUSE" ] && [ "$OS_VERSION" = "12" ]; then
		 echo "#######################################################" | log
		 echo "Verifying if following packages are present or not for $OSNAME linux. Installing required packages..." | log
		 sudo SUSEConnect -p sle-module-web-scripting/12/x86_64
		 sudo zypper refresh
		 sudo zypper --non-interactive install autoconf gcc glibc libmcrypt-devel make libopenssl-devel wget sysstat git subversion net-tools bind-utils
		 echo "#######################################################" | log 
		 echo "Starting Sysstat tool for monitoring" | log 
		 systemctl enable sysstat && systemctl start sysstat
		 echo "#######################################################" | log 
		 groupadd groots && usermod -g groots groots >/dev/null 

	fi
	
	# Check Selinux mode
	verify_selinux 

        # Gmetrics remote user addition.
        gmetrics_agent_user_addition

        # Gmetrics remote plugin directory creation.
        gmetrics_agent_plugin_directory_addition

        # Verify permission for /groots directory
        verify_groots_dir_permission

        # Get ip address from system.
        gmetrics_agent_getipaddress

	# Verify agent service log path
	verify_log_path_permission

        # Changing permissions of file /bin/ping and /bin/ping6
        gmetrics_agent_change_ping_permission

	if [ "$OSNAME" = "CentOS" ] && [ "$OS_VERSION" = "8" ]; then
	gmetrics_agent_centos8_untarzipfile

	elif [ "$OSNAME" = "CentOS" ] && [ "$OS_VERSION" = "7" ]; then
	gmetrics_agent_centos7_untarzipfile

	elif [ "$OSNAME" = "Amazon" ]; then
	gmetrics_agent_amazon_linux_untarzipfile
	
	elif [ "$OSNAME" = "SUSE" ] && [ "$OS_VERSION" = "12" ]; then
	gmetrics_agent_suse_untarzipfile
	fi

        # Gmetrics agent port entry add in /etc/services file.
        gmetrics_agent_service_port_entry

        # Gmetrics agent user entry add in Sudoers File.
        gmetrics_agent_sudoers_entry

        # Adding agent server LAN IP in gmetrics-agent config file.
        gmetrics_agent_assign_ipaddress

        # Adding gmetrics-agent port in firewall.
        gmetrics_agent_firewall

        # Start gmetrics-agent services.
        gmetrics_agent_service_start

        # Verify gmetrics-agent service status.
        gmetrics_agent_connectivity_test

        echo "#######################################################" | log

elif [ "$OSNAME" = "Ubuntu" ]; then
        echo "#######################################################" | log
        echo "Gmetrics agent installtion starting at [`date`]." | log
	echo "#######################################################" | log
	echo "Packages installation requires Internet connection. " | log 
        echo "#######################################################" | log
        echo "Verifying if following packages are present or not." | log
        echo "#######################################################" | log
        echo "You need to install these os libraries packages on the server : telnet libgd-dev libmcrypt-dev libssl-dev dc snmp libnet-snmp-perl sysstat openssl vim dos2unix git" | log
	echo "#######################################################" | log
	echo "Installing required packages for Ubuntu" | log  
	apt install -y sysstat gcc glibc glibc-common gd gd-devel make net-snmp openssl-devel bind-utils net-snmp-devel net-snmp-utils net-snmp-perl git subversion 

        # Gmetrics agent user addition.
        gmetrics_agent_user_addition

        # Gmetrics agent plugin directory creation.
        gmetrics_agent_plugin_directory_addition

        # Verify permission for /groots directory
        verify_groots_dir_permission

        # Get ip address from system.
        gmetrics_agent_getipaddress

	# Verify agent service log path 
	verify_log_path_permission

        # Changing permissions of file /bin/ping and /bin/ping6
        gmetrics_agent_change_ping_permission

        # Extracting gmetrics-agent tar file.
        gmetrics_agent_ubuntu_untarzipfile

        # Gmetrics agent port entry add in /etc/services file.
        gmetrics_agent_service_port_entry

        # Gmetrics agent user entry add in Sudoers File.
        gmetrics_agent_sudoers_entry

        # Adding agent server LAN IP in gmetrics-agent config file.
        gmetrics_agent_assign_ipaddress

        # Adding gmetrics-agent port in firewall.
        gmetrics_agent_firewall

        # Start gmetrics-agent services.
        gmetrics_agent_service_start

        # Verify gmetrics-agent service status.
        gmetrics_agent_connectivity_test

        echo "#######################################################" | log
fi

echo "Gmetrics Agent plugin executor is successfully installed." | log
echo "Gmetrics Agent Installation is completed at [`date`]." | log
echo "Remove tmp files from /groots/tmp/" | log
rm -rf /groots/tmp/* > /dev/null

echo "
NOTE : If gmetrics-agent installation does not started then check installation log file [$LOGFILE]
       And gmetrics-agent service log file [$LOGDIR/gmetrics-agent.log]
       Or your system log file.
" | log

# Server information to monitor this hosts.
LINUX_SERVER_IP=`dig +short myip.opendns.com @resolver1.opendns.com`
OFFICIAL_EMAILID="john@example.com"
ORGANIZATION_NAME="Groots Software Technologies Pvt Ltd."
echo "Copy following content and sent it to \"support@groots.in\" email address" | tee -a $LOGFILE
echo "
Server Public IP: $LINUX_SERVER_IP
Monitoring Hostname: $HOSTNAME
Official Email-id: $OFFICIAL_EMAILID               # Replace given email id with your email id
Organization Name: $ORGANIZATION_NAME              # Replace given organization name with your organization name.
" | tee -a $LOGFILE

echo "Open monitoring port \"5666\" on your firewall for \"3.7.198.168\" to start monitoring in gmetrics" | tee -a $LOGFILE

# End Main Logic.
#######################################################
