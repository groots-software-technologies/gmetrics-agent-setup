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

## Verify

1. Verify if svn and git package present or not on remote server

$ svn --version 
$ git --version 

2. if packages are not present then install using 

$ yum install subversion -y -- Centos7
$ yum install git -y -- Centos7

$ apt-get install subersion -- Ubuntu 
$ apt-get install git -- Ubuntu

## Agent installation 

$ curl -s -k https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/alpha/v5/bin/gmetrics_agent_setup.sh | bash

- Check & verify service log file
$ tail -f /var/log/groots/metrics/gmetrics-agent.log

## Testing
- Verify gmetrics agent service status

$ systemctl enable gmetrics-remote

$ systemctl status gmetrics-remote

- Test port connectivity from Locally

$ telnet localhost 5666

$ telnet <REMOTE AGENT PRIVATE IP/HOSTNAME> 5666

- Test port connectivity from Gmetrics-Core cloud server

$ telnet <REMOTE AGENT IP/HOSTNAME> 5666

