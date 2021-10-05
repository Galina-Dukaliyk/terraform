resource "google_sql_database_instance" "petclinic_sql" {
  name             = var.db_instance_name
  database_version = var.db_version
  region           = var.my_region
  settings {
    tier = var.machine_type
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.my_network
    }
  }
}

resource "google_sql_database" "petclinic_db" {
  name     = var.database_sql_name
  instance = google_sql_database_instance.petclinic_sql.id
}

resource "google_sql_user" "user" {
  name     = var.db_user_name
  instance = google_sql_database_instance.petclinic_sql.id
  password = var.db_user_password
}
