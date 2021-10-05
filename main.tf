module "gce_instance" {
  source         = "./modules/instance"
  my_zone        = "${var.my_region}-b"
  my_image       = "petclinic-instance-image-v2"
  my_inst_name   = "petclinic-app-tf"
  mach_type      = "n1-standard-1"
  static_ip_addr = module.network.static_ip
  network_name   = module.network.network_name
}

module "network" {
  source         = "./modules/network"
  static_ip_name = "petclinic-public-ip-tf"
  name_vpc       = "petclinic-vpc-tf"
  my_subnet      = "petclinic-subnet-tf-eu-west1"
  ip_range       = "10.24.5.0/24"
}



resource "google_compute_instance" "petclinic-app-tf" {
  name                      = "petclinic-app-tf"
  machine_type              = "n1-standard-1"
  zone                      = "${var.my_region}-b"
  tags                      = ["ssh", "web"]
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = data.google_compute_image.petclinic_image.self_link
    }
  }
  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}
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
data "google_compute_image" "petclinic_image" {
  name = "petclinic-instance-image-v2"
}
