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