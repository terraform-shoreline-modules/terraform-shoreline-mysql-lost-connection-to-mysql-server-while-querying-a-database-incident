
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Lost connection to MySQL server while querying a database incident.
---

This incident type occurs when there is a loss of connection to the MySQL server during the process of querying a database. This can happen due to various reasons such as network issues, server overload, or software errors. As a result, the query execution fails and users may experience disruptions in accessing data from the database. It is critical to resolve this issue promptly to avoid data loss or corruption.

### Parameters
```shell
export APPLICATION_SERVER_IP="PLACEHOLDER"
export MYSQL_PASSWORD="PLACEHOLDER"
export MYSQL_DATABASE_NAME="PLACEHOLDER"
export MYSQL_USERNAME="PLACEHOLDER"
export MYSQL_SERVER_IP_ADDRESS="PLACEHOLDER"
export DB_PORT="PLACEHOLDER"
export VALUE="PLACEHOLDER"
export PREVIOUS_VALUE="PLACEHOLDER"
```

## Debug

### Check if MySQL server is running
```shell
systemctl status mysql
```

### Check if MySQL server is listening on the correct port
```shell
sudo netstat -tulpn | grep 3306
```

### Check MySQL server logs for errors
```shell
sudo tail -f /var/log/mysql/error.log
```

### Check MySQL client logs for errors
```shell
sudo tail -f /var/log/mysql/mysql.log
```

### Check if there are any network issues
```shell
ping ${MYSQL_SERVER_IP_ADDRESS}
```

### Check if there is enough disk space available
```shell
df -h
```

### Check if there are any issues with the database tables
```shell
mysql -u ${MYSQL_USERNAME} -p ${MYSQL_PASSWORD} -e "USE ${MYSQL_DATABASE_NAME}; SHOW TABLES;"
```

### Check if there are any locked tables
```shell
mysql -u ${MYSQL_USERNAME} -p ${MYSQL_PASSWORD} -e "SHOW OPEN TABLES WHERE In_use > 0;"
```

### Check if there are any long-running queries
```shell
mysql -u ${MYSQL_USERNAME} -p ${MYSQL_PASSWORD} -e "SHOW FULL PROCESSLIST;"
```

### Check the network connectivity between the application server and the database server. Make sure there are no firewall rules or network issues blocking the connection.
```shell

#!/bin/bash
APP_SERVER=${APPLICATION_SERVER_IP}
DB_SERVER=${MYSQL_SERVER_IP_ADDRESS}

ping -c 4 $APP_SERVER > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Application server is reachable."
else
  echo "Application server is not reachable."
fi

ping -c 4 $DB_SERVER > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Database server is reachable."
else
  echo "Database server is not reachable."
fi

nc -zv $DB_SERVER 3306 > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "Connection to MySQL server is successful."
else
  echo "Connection to MySQL server failed."
fi

```

### The network connection to the MySQL server may have been disrupted or lost.
```shell
#!/bin/bash
# Define variables
MYSQL_HOST=${MYSQL_SERVER_IP_ADDRESS}
MYSQL_USER=${MYSQL_USERNAME}
MYSQL_PASSWORD=${MYSQL_PASSWORD}
MYSQL_DATABASE=${MYSQL_DATABASE_NAME}

# Test MySQL connection
echo "Testing MySQL connection to $MYSQL_HOST..."
if mysql -h $MYSQL_HOST -u $MYSQL_USER -p $MYSQL_PASSWORD -e "use $MYSQL_DATABASE;"; then
    echo "MySQL connection successful."
else
    echo "MySQL connection failed - network connection may have been disrupted or lost."
fi

```

## Repair
### Increase the timeout value for the connection to the MySQL server to allow for longer queries to complete. This can be done in the application code or in the MySQL server configuration.
```shell
#!/bin/bash

# Set the timeout value for the MySQL server connection
timeout_value=${VALUE}

# Update the MySQL server configuration file to include the new timeout value
sudo sed -i "s/timeout=${PREVIOUS_VALUE}/timeout=$timeout_value/g" /etc/mysql/my.cnf

# Restart the MySQL server to apply the new configuration
sudo service mysql restart

echo "Timeout value updated to $timeout_value seconds."
```