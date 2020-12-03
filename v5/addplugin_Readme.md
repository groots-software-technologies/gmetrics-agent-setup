# Add remote side plugin

## Summary
To copy gmetrics plugins from git to remote host's /groots/metrics/libexec directory

# Execution 

### Help Usage & get plugin list

bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/alpha/v5/bin/addplugin.sh) -h 

### To add plugins

bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-setup/alpha/v5/bin/addplugin.sh) -p (pluginname)

- Plugins will get copied to groots/metrics/libexec directory

### Refer log

cat /var/log/groots/metrics/addplugin.sh.log

