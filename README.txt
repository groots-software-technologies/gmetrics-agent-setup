
# Gmetrics remote Agent installation

# Purpose

 This script installs gmetrics-remote Agent on the remote systems. (Centos7/Ubuntu)

# Introduction

 Steps involved in the installation one by one:

* Checking the OS background and installing packages
* Gmetrics remote User aaddition  
* Gmetrics remote plugin directory creation 
* Gmetrics remote pulling ipaddress of system 
* Changing ping file permission 
* Gmetrics remote plugins download to plugin dir  
* Gmetrics remote extracting taragent zip file
* Gmetrics remote service port entry 
* Gmetrics remote user sudoers entry 
* Assigning LANIP address in config file
* Gmetrics remote port adding in firewall
* Enable and Start the Gmetrics remote service
* Gmetrics remote connectivity test

# Verifying git availability

$ git --version 

* Clone in /root/gmetricsdata directory, 

$ mkdir /root/gmetricsdata

$ cd /root/gmetricsdata/

* Pull from master branch.

$ echo 'svn checkout https://github.com/grootsadmin/groots-metrics/trunk/gmetrics-remote-agent --non-interactive --no-auth-cache --username <ASSOCIATED USER> --password <ASSOCIATED PASSWORD>' > gmetrics-git.sh

* Pull from specific branch.

$ echo 'svn checkout https://github.com/grootsadmin/groots-metrics/branches/master/gmetrics-remote-agent --non-interactive --no-auth-cache --username <ASSOCIATED USER> --password <ASSOCIATED PASSWORD>' > gmetrics-git.sh

# Edit and add git hub ASSOCIATED USER and PASSWORD.

$ vi gmetrics-git.sh

# Execute script.

$ sh gmetrics-git.sh

# Instruction 
 
* Installation of packages are commented, as the necessary packages can be installed manually later as required.
 
* Gmetrics remote Agent tar files are placed in  
 
$ cd /root/gmetricsdata/gmetrics-remote-agent/
  
* Scripts are placed under 
 
$ cd /root/gmetricsdata/gmetrics-remote-agent/  
 
* execute remote agent installation script (to be run as root),  

$ sh /root/gmetricsdata/gmetrics-remote-agent/gmetrics_agent_setup.sh

* If gmetrics-remote service does not started then refer installation log file which is generated at, 
  
$ cat /var/log/groots/gmetrics/gmetrics_agent_setup.sh.log
  
* And gmetrics-remote service log file at, 

$ cat /groots/monitoring/var/gmetrics-remote.log 
  
# Testing gmetrics  remote agent.

* Locally test, 

$ telnet localhost 5666

$ telnet <REMOTE AGENT PRIVATE IP/HOSTNAME> 5666

* Test from core server.

$ telnet <REMOTE AGENT IP/HOSTNAME> 5666
 
# Download plugin from github.

* Gmetrics plugins directories are placed in

$ cd /root/gmetricsdata/

* Pull from master branch.

$ echo 'svn checkout https://github.com/grootsadmin/groots-metrics/trunk/gmetrics-remote-plugin --non-interactive --no-auth-cache --username <ASSOCIATED USER> --password <ASSOCIATED PASSWORD>' > gmetrics-plugins-git.sh

* Pull from specific branch.

$ echo 'svn checkout https://github.com/grootsadmin/groots-metrics/branches/master/gmetrics-remote-plugin --non-interactive --no-auth-cache --username <ASSOCIATED USER> --password <ASSOCIATED PASSWORD>' > gmetrics-plugins-git.sh

# Edit and add git hub ASSOCIATED USER and PASSWORD.

$ vi gmetrics-plugins-git.sh

# Execute script.

$ sh gmetrics-plugins-git.sh

$ cd /root/gmetricsdata/gmetrics-remote-plugin/

$ /root/gmetricsdata/gmetrics-remote-plugin/
  
# Copy the plugins as per appllication and plugins should be placed under "/groots/monitoring/libexec" path.

* cp -av /root/gmetricsdata/gmetrics-remote-plugin/<APPNAME DIR>/* /groots/monitoring/libexec/

# Appsensors plugins : 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/appsensors/* /groots/monitoring/libexec/

# Aws plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/aws/* /groots/monitoring/libexec/  

# Backup plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/backup/* /groots/monitoring/libexec/  

# Dnsrecords plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/dnsrecords/* /groots/monitoring/libexec/  

# Docker plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/docker/* /groots/monitoring/libexec/

# Expiry plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/expiry/* /groots/monitoring/libexec/

# Hardware plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/hardware/* /groots/monitoring/libexec/

# Kubernetes plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/kubernetes/* /groots/monitoring/libexec/

# Lamp plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/lamp/* /groots/monitoring/libexec/

# Mithi plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/mithi/* /groots/monitoring/libexec/

# Os plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/os/* /groots/monitoring/libexec/

# Website plugins 
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/website/* /groots/monitoring/libexec/

# Zimbra plugins
$ cp -av /root/gmetricsdata/gmetrics-remote-plugin/zimbra/* /groots/monitoring/libexec/ 

# Error : 
If you got following error in monitoring.

ERROR : "Is there a typo in the command or service configuration?: sudo: sorry, you must have a tty to run sudo"

Then execute following command and reschedule command and check the result.

$ cp -av /etc/sudoers /etc/sudoers_<DATE>

$ sed -i -e 's/Defaults    requiretty.*/#Defaults    requiretty/g' /etc/sudoers

# NOTE : 
       Once all installation is done then cleanup data from "/root/gmetricsdata/" directory.
       
$ rm -rf /root/gmetricsdata/*

$ ls -ltrh /root/gmetricsdata/

# License
  This program is distributed in the hope that it will be useful,
  but under groots software technologies @rights.
