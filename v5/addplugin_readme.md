# Add remote side plugin to remote host libexec

## Summary

This copies gmetrics plugins from git gmetrics-plugin main repo to remote server's /groots/metrics/libexec directory. Following is the list of plugins available to copy from list below -

**list=("sms" "appsensors" "aws" "backup" "dns" "docker" "elk" "expiry" "hardware" "lamp" "mithi" "os" "website" "jvm" "node" "jenkins")**


## Execution 

### Help Usage & get plugins list
```
bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/master/v5/bin/gmetrics_agent_plugin_add.sh) -h 
```
### To run and execute plugin addition script

- For Master
```
$ bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/master/v5/bin/gmetrics_agent_plugin_add.sh) -p (pluginname)
```
- Mentioned plugin name will get copied to /groots/metrics/libexec directory after successfully execution of script. Commands for these plugins will be pre mentioned in /groots/metrics/config/gmetrics-agent.cfg. On Gmetrics core add service templates for the same plugin under `/groots/metrics/config/etc/servers/<HOSTNAME>/`

### Refer log 

cat /var/log/groots/gmetrics/gmetrics_agent_plugin_add.sh.log 
