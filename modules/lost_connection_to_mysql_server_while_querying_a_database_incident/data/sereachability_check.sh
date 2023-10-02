
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