# Gmetrics Hosts and service monitoring plugins.

### These plugins are depends only Gmetrics Monitoring not applicable for other monitoring tool.
For reference refer https://www.groots.in/monitor and for gmetrics login refer https://metrics.groots.in url.

### Help Usage & get plugin lists

```bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-plugins/main/gmetrics_agent_plugin_add.sh) -h```

### Command for add gmetrics agent plugin for monitor hosts and services.

```bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-plugins/main/gmetrics_agent_plugin_add.sh) -p [PLUGIN NAME]```

Ex:

```bash <(curl -Ls https://raw.githubusercontent.com/grootsadmin/gmetrics-agent-plugins/main/gmetrics_agent_plugin_add.sh) -p os```

### Refer log file for more detail.

```cat /var/log/groots/gmetrics/gmetrics_agent_plugin_add.sh.log ```
