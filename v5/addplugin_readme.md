# Add remote side plugin to remote host libexec

## Summary

This copies gmetrics plugins from git gmetrics-plugin main repo to remote host's /groots/metrics/libexec directory. Following is the list of plugins available to copy-
list=("sms" "appsensors" "aws" "backup" "dns" "docker" "elk" "expiry" "hardware" "lamp" "mithi" "os" "website" "jvm" "node" "jenkins")


# Execution 

#### Help Usage & get plugin list
```
bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/[branch]/v5/bin/gmetrics_agent_plugin_add.sh) -h 
```
### To run and execute plugin addition script
- For Master
```
$ bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/main/v5/bin/gmetrics_agent_plugin_add.sh) -p (pluginname)
```
- For Branch
```
$ bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/[branch]/v5/bin/gmetrics_agent_plugin_add.sh) -p (pluginname)
```
Ex:
```
$ bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/alpha/v5/bin/gmetrics_agent_plugin_add.sh) -p (pluginname)
```
- Plugins will get copied to /groots/metrics/libexec directory

### Refer log

cat /var/log/groots/metrics/gmetrics_agent_plugin_add.sh.log 
