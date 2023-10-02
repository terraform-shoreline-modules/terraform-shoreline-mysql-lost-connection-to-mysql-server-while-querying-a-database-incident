terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "lost_connection_to_mysql_server_while_querying_a_database_incident" {
  source    = "./modules/lost_connection_to_mysql_server_while_querying_a_database_incident"

  providers = {
    shoreline = shoreline
  }
}