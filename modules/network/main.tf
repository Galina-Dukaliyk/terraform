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
