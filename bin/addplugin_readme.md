# Summary
To start application performance monitoring by using gmetrics-plugin. To download plugin script & execute on your
remote server. After that, immediately application monitoring will start.

Read to plug - sms, appsensors, aws, backup, dns, docker, expiry, hardware, lamp, mithi, os, website, zimbra, mail
website, jvm.

# Download

- Download plugin script

To clone git repo in /root directory

$ git clone https://github.com/grootsadmin/gmetrics-agent-setup.git 

- Downloaded script path
 
$ cd /root/gmetrics-agent-setup/bin/

- Copy script onto /groots/monitoring/bin folder

cp /root/gmetrics-agent-setup/bin/addplugin.sh /groots/monitoring/bin/

- Check addplugin script usage & decide which plugin you have to monitor into gmetrics dashboard.

$ sh addplugin.sh --help

$ sh addplugin.sh -p [plugin name]

You will get the plugin list & decide which you have to monitor.

# Plugin addition

- Add plugin
$ sh addplugin.sh -p [plugin name]

Ex - sh addpluigin.sh -p aws

- Plugin command addition into gmetrics-remote.cfg file.



- Restart gmetrics-remote service
systemctl status gmetrics-remote

systemctl restart gmetrics-remote

systemctl status gmetrics-remote

# Note

1] After successful addition of plugin, copy all performance related script & library file into "/groots/monitoring/libexec"
remote system.

2] Before testing, enable this plugin at gmetircs-core side, & pull the perf data from remote system to gmetrics-core.
