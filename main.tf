# resource "google_compute_instance" "instance1" {
#   name         = "instance1"
#   machine_type = "f1-micro"
#   zone         = "europe-west1-b"
#
#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-9"
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
resource "google_compute_address" "static" {
  name = "petclinic-public-ip-tf"
}

resource "google_compute_subnetwork" "petclinic-subnet-tf-eu-west1" {
  name          = "petclinic-subnet-tf-eu-west1"
  ip_cidr_range = "10.24.5.0/24"
  network       = google_compute_network.petclinic-vpc-tf.id
}

resource "google_compute_network" "petclinic-vpc-tf" {
  name                    = "petclinic-vpc-tf"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "ssh_rule" {
  name    = "petclinic-allow-ssh-tf"
  network = google_compute_network.petclinic-vpc-tf.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["ssh"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http_rule" {
  name    = "petclinic-allow-http-tf"
  network = google_compute_network.petclinic-vpc-tf.id

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  target_tags   = ["web"]
  source_ranges = ["0.0.0.0/0"]
}
