data "google_compute_image" "petclinic_image" {
  name = var.my_image
}
resource "google_compute_instance" "petclinic-app-tf" {
  name                      = var.my_inst_name
  machine_type              = var.mach_type
  zone                      = var.my_zone
  tags                      = var.instance_tag
  allow_stopping_for_update = true
  service_account {
    email  = var.name_serv_account
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.petclinic_image.self_link
    }
  }
  network_interface {
    network    = var.network_name
    subnetwork = var.my_subnet

    access_config {
      nat_ip = var.static_ip_addr
    }
  }
}
