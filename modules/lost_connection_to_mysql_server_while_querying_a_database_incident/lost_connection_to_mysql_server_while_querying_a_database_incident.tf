resource "shoreline_notebook" "lost_connection_to_mysql_server_while_querying_a_database_incident" {
  name       = "lost_connection_to_mysql_server_while_querying_a_database_incident"
  data       = file("${path.module}/data/lost_connection_to_mysql_server_while_querying_a_database_incident.json")
  depends_on = [shoreline_action.invoke_sereachability_check,shoreline_action.invoke_mysql_connection_test,shoreline_action.invoke_update_mysql_timeout]
}

resource "shoreline_file" "sereachability_check" {
  name             = "sereachability_check"
  input_file       = "${path.module}/data/sereachability_check.sh"
  md5              = filemd5("${path.module}/data/sereachability_check.sh")
  description      = "Check the network connectivity between the application server and the database server. Make sure there are no firewall rules or network issues blocking the connection."
  destination_path = "/agent/scripts/sereachability_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "mysql_connection_test" {
  name             = "mysql_connection_test"
  input_file       = "${path.module}/data/mysql_connection_test.sh"
  md5              = filemd5("${path.module}/data/mysql_connection_test.sh")
  description      = "The network connection to the MySQL server may have been disrupted or lost."
  destination_path = "/agent/scripts/mysql_connection_test.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_mysql_timeout" {
  name             = "update_mysql_timeout"
  input_file       = "${path.module}/data/update_mysql_timeout.sh"
  md5              = filemd5("${path.module}/data/update_mysql_timeout.sh")
  description      = "Increase the timeout value for the connection to the MySQL server to allow for longer queries to complete. This can be done in the application code or in the MySQL server configuration."
  destination_path = "/agent/scripts/update_mysql_timeout.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_sereachability_check" {
  name        = "invoke_sereachability_check"
  description = "Check the network connectivity between the application server and the database server. Make sure there are no firewall rules or network issues blocking the connection."
  command     = "`chmod +x /agent/scripts/sereachability_check.sh && /agent/scripts/sereachability_check.sh`"
  params      = ["APPLICATION_SERVER_IP","MYSQL_SERVER_IP_ADDRESS"]
  file_deps   = ["sereachability_check"]
  enabled     = true
  depends_on  = [shoreline_file.sereachability_check]
}

resource "shoreline_action" "invoke_mysql_connection_test" {
  name        = "invoke_mysql_connection_test"
  description = "The network connection to the MySQL server may have been disrupted or lost."
  command     = "`chmod +x /agent/scripts/mysql_connection_test.sh && /agent/scripts/mysql_connection_test.sh`"
  params      = ["MYSQL_USERNAME","MYSQL_PASSWORD","MYSQL_DATABASE_NAME","MYSQL_SERVER_IP_ADDRESS"]
  file_deps   = ["mysql_connection_test"]
  enabled     = true
  depends_on  = [shoreline_file.mysql_connection_test]
}

resource "shoreline_action" "invoke_update_mysql_timeout" {
  name        = "invoke_update_mysql_timeout"
  description = "Increase the timeout value for the connection to the MySQL server to allow for longer queries to complete. This can be done in the application code or in the MySQL server configuration."
  command     = "`chmod +x /agent/scripts/update_mysql_timeout.sh && /agent/scripts/update_mysql_timeout.sh`"
  params      = ["VALUE","PREVIOUS_VALUE"]
  file_deps   = ["update_mysql_timeout"]
  enabled     = true
  depends_on  = [shoreline_file.update_mysql_timeout]
}

