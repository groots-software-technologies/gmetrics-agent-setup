
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

$ git clone https://github.com/grootsadmin/gmetrics-agent-setup.git
 
* Installation of packages are commented, as the necessary packages can be installed manually later as required.
 
* Gmetrics remote Agent tar files are placed in  
 
$ cd /root/gmetricsdata/gmetrics-remote-agent/
  
* Scripts are placed under 
 
$ cd /root/gmetricsdata/gmetrics-remote-agent/  
 
* execute remote agent installation script (to be run as root),  

$ sh /root/gmetricsdata/gmetrics-remote-agent/bin/gmetrics_agent_setup.sh

* If gmetrics-remote service does not started then refer installation log file which is generated at, 
  
$ cat /var/log/groots/gmetrics/gmetrics_agent_setup.sh.log
  
* And gmetrics-remote service log file at, 

$ cat /var/log/groots/gmetrics/gmetrics_agent_setup.sh.log
  
# Testing gmetrics  remote agent.

* Locally test, 

$ telnet localhost 5666

$ telnet <REMOTE AGENT PRIVATE IP/HOSTNAME> 5666

* Test from core server.

$ telnet <REMOTE AGENT IP/HOSTNAME> 5666
 
# Download plugin from github.

* Gmetrics plugins directories are placed in

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
