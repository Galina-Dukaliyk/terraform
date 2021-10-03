resource "google_compute_instance" "instance1" {
  name         = "instance1"
  machine_type = "f1-micro"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-10-buster-v20210916"
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
  name = "ipv4-address"
}
