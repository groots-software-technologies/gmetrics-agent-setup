# Gmetrics Agent Installation

## Summary
By using this agent installation script, you will install the gmetrics-agent. Through this agent perf data will sync with gmetrics-core

## Gmetrics-agent script flow - 
- Check OS background & start installation
- Add gmetrics-agent system user
- Create gmetrics agent directory strcture
- Pull remote server IP address
- Change ping file permission
- Change and verify log file path ownership
- Download tar files using svn from repo and store in /groots/tmp/
- Download gmetrics-plugin config files & store into gmetrics-agent 
- Add entry for gmetrics-agent service port 
- Add gmetrics-agent user entry into sudoers file
- Assign LAN IP address into config file
- Add gmetrics-agent port into server level firewall
- Enable & start gmetrics-agent service
- Test gmetrics-agent connectivity
- Clean /groots/tmp directory

## Verify

1. Verify if svn and git package present or not on remote server

$ svn --version 

$ git --version 

2. if packages are not present then install using 

- Centos:

$ yum install subversion -y  

$ yum install git -y 

- Ubuntu:

$ apt-get install subversion -y 

$ apt-get install git -y 

## Gmetrics agent installation on remote server

$ cd /root

$ echo "branches/<branch>" | bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/[branch]/v5/bin/gmetrics_agent_setup.sh)
 
Ex:
 
$ echo "branches/alpha" | bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/alpha/v5/bin/gmetrics_agent_setup.sh)

- Check & verify service log file

$ tail -f /var/log/groots/metrics/gmetrics-agent.log

- To check installation script log, refer

$ tail -f /var/log/groots/metrics/gmetrics_agent_setup.sh.log

## Testing

- Verify gmetrics agent service status

$ systemctl enable gmetrics-agent

$ systemctl status gmetrics-agent

- Check gmetrics-agent listening port 

$ netstat -tulpn | grep 5666

- Test port connectivity from Locally

$ telnet localhost 5666

$ telnet <REMOTE AGENT PRIVATE IP/HOSTNAME> 5666

- Test port connectivity from Gmetrics-Core cloud server

$ telnet <REMOTE AGENT IP/HOSTNAME> 5666

- Check gmetrics plugins

$ sudo /groots/metrics/libexec/check_metrics -H 127.0.0.1

$ sudo /groots/metrics/libexec/check_metrics -H <IP> -c check_users -a '-w 5 -c 8'


## Error
- If you get following error after agent installation, perform the below task.

-ERROR 
"Is there a typo in the command or service configuration?: sudo: sorry, you must have a tty to run sudo"

- Execute following command and check the result.

$ cp -av /etc/sudoers /etc/sudoers\_\<DATE\>

$ sed -i -e 's/Defaults    requiretty.*/#Defaults    requiretty/g' /etc/sudoers

### Gmetrics Agent Uninstallation.
Execute following command to remove gmetrics agent from your server.

$ curl -s -k https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/[branch]/v5/bin/gmetrics_agent_uninstall.sh | bash

Ex: 

$ curl -s -k https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/alpha/v5/bin/gmetrics_agent_uninstall.sh | bash

