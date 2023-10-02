#!/bin/bash

# Set the timeout value for the MySQL server connection
timeout_value=${VALUE}

# Update the MySQL server configuration file to include the new timeout value
sudo sed -i "s/timeout=${PREVIOUS_VALUE}/timeout=$timeout_value/g" /etc/mysql/my.cnf

# Restart the MySQL server to apply the new configuration
sudo service mysql restart

echo "Timeout value updated to $timeout_value seconds."