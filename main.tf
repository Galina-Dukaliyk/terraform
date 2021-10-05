resource "random_id" "db_name_suffix" {
  byte_length = 5
}

module "gce_instance" {
  source         = "./modules/instance"
  my_zone        = "${var.my_region}-b"
  instance_tag   = ["ssh", "web"]
  my_image       = "petclinic-instance-image-v2"
  my_inst_name   = "petclinic-app-tf"
  mach_type      = "n1-standard-1"
  static_ip_addr = module.network.static_ip
  network_name   = module.network.network_name
  my_subnet      = "petclinic-subnet-tf-eu-west1"
}

module "network" {
  source         = "./modules/network"
  static_ip_name = "petclinic-public-ip-tf"
  name_vpc       = "petclinic-vpc-tf"
  my_subnet      = "petclinic-subnet-tf-eu-west1"
  ip_range       = "10.24.5.0/24"
  private_ip     = "private-ip-address"
}

module "firewall_ssh" {
  source        = "./modules/firewall"
  rule_name     = "petclinic-allow-ssh-tf"
  network_name  = module.network.network_name
  protocol      = "tcp"
  port          = ["22"]
  tag           = ["ssh"]
  ranges_source = ["0.0.0.0/0"]
}

module "firewall_web" {
  source        = "./modules/firewall"
  rule_name     = "petclinic-allow-http-tf"
  network_name  = module.network.network_name
  protocol      = "tcp"
  port          = ["8080"]
  tag           = ["web"]
  ranges_source = ["0.0.0.0/0"]
}

module "sql" {
  source            = "./modules/sql"
  db_version        = "MYSQL_5_7"
  db_instance_name  = "petclinic-db-tf-${random_id.db_name_suffix.dec}"
  my_region         = var.my_region
  machine_type      = "db-n1-standard-2"
  my_network        = module.network.network_name
  database_sql_name = "petclinic"
  db_user_name      = "petclinic"
  db_user_password  = var.db_user_pswd
  depends_on        = [module.network]
}






# resource "google_compute_instance" "petclinic-app-tf" {
#   name                      = "petclinic-app-tf"
#   machine_type              = "n1-standard-1"
#   zone                      = "${var.my_region}-b"
#   tags                      = ["ssh", "web"]
#   allow_stopping_for_update = true
#
#   boot_disk {
#     initialize_params {
#       image = data.google_compute_image.petclinic_image.self_link
#     }
#   }
#   network_interface {
#     network = "default"
#
#     access_config {
#       nat_ip = google_compute_address.static.address
#     }
#   }
# }
# resource "google_compute_address" "static" {
#   name = "petclinic-public-ip-tf"
# }
#
# resource "google_compute_subnetwork" "petclinic-subnet-tf-eu-west1" {
#   name          = "petclinic-subnet-tf-eu-west1"
#   ip_cidr_range = "10.24.5.0/24"
#   network       = google_compute_network.petclinic-vpc-tf.id
# }
#
# resource "google_compute_network" "petclinic-vpc-tf" {
#   name                    = "petclinic-vpc-tf"
#   auto_create_subnetworks = false
# }
#
# resource "google_compute_firewall" "ssh_rule" {
#   name    = "petclinic-allow-ssh-tf"
#   network = google_compute_network.petclinic-vpc-tf.id
#
#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }
#   target_tags   = ["ssh"]
#   source_ranges = ["0.0.0.0/0"]
# }
#
# resource "google_compute_firewall" "http_rule" {
#   name    = "petclinic-allow-http-tf"
#   network = google_compute_network.petclinic-vpc-tf.id
#
#   allow {
#     protocol = "tcp"
#     ports    = ["8080"]
#   }
#   target_tags   = ["web"]
#   source_ranges = ["0.0.0.0/0"]
# }
# data "google_compute_image" "petclinic_image" {
#   name = "petclinic-instance-image-v2"
# }
