resource "google_compute_address" "static" {
  name = var.static_ip_name
}

resource "google_compute_network" "petclinic-vpc-tf" {
  name                    = var.name_vpc
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "petclinic-subnet-tf-eu-west1" {
  name          = var.my_subnet
  ip_cidr_range = var.ip_range
  network       = google_compute_network.petclinic-vpc-tf.id
}

resource "google_compute_global_address" "private_ip_address" {
  name          = var.private_ip
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.petclinic-vpc-tf.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.petclinic-vpc-tf.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
