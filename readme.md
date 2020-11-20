# Gmetrics Agent Installation

## Summary
By using this agent installation script, you will install the gmetrics-agent. Through this agent perf data will sync with gmetrics-core

## Gmetrics-agent script flow - 
- Check OS background & start installation
- Add gmetrics-agent system user
- Create gmetrics agent directory strcture
- Pull remote server IP address
- Change ping file permission
- Download gmetrics-plugin config files & store into gmetrics-agent 
- Add entry for gmetrics-agent service port 
- Add gmetrics-agent user entry into sudoers file
- Assign LAN IP address into config file
- Add gmetrics-agent port into server level firewall
- Enable & start gmetrics-agent service
- Test gmetrics-agent connectivity

## Install at Linux Platform -
OS type - RHEL7/CENTOS7, UBUNTU, Amazon Linux

## Download 
- Download gmetircs-agent package on remote server. Confirm git package present on your remote system or not. If git package is not present then install it.

$ git --version 

- Create & download agent package into /root/gmetricsdata directory - 

$ mkdir /root/gmetricsdata

$ cd /root/gmetricsdata/

- Pull package from master.

$ git clone https://github.com/grootsadmin/gmetrics-agent-setup.git
 
Note : 
Installation of packages are commented, as the necessary packages can be installed manually later as required.
 
- Confirm gmetrics agent files
 
$ cd /root/gmetricsdata/gmetrics-agent-setup
 
## Installation
- Install gmetrics-agent & execute below script by using root system user.

$ sudo sh /root/gmetricsdata/gmetrics-agent-setup/bin/gmetrics_agent_setup.sh

- Confirm gmetrics-agent service, & if it will not auto-start, check installation log.
  
$ cat /var/log/groots/gmetrics/gmetrics_agent_setup.sh.log
  
- And gmetrics-remote service log file at, 

$ cat /groots/monitoring/var/gmetrics-agent.log
  
## Testing
- Verify gmetrics agent service status

$ systemctl enable gmetrics-agent

$ systemctl status gmetrics-agent

- Test port connectivity from Locally

$ telnet localhost 5666

$ telnet <REMOTE AGENT PRIVATE IP/HOSTNAME> 5666

- Test port connectivity from Gmetrics-Core cloud server

$ telnet <REMOTE AGENT IP/HOSTNAME> 5666

## Error
If you get following error after agent installation, perform the below task.

ERROR - 
"Is there a typo in the command or service configuration?: sudo: sorry, you must have a tty to run sudo"

Execute following command and check the result.

$ cp -av /etc/sudoers /etc/sudoers_<DATE>

$ sed -i -e 's/Defaults    requiretty.*/#Defaults    requiretty/g' /etc/sudoers

## NOTE
- Once all installation is done then cleanup data from "/root/gmetricsdata/" directory.
      
$ rm -rf /root/gmetricsdata/*

$ ls -ltrh /root/gmetricsdata/
