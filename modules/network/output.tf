output "static_ip" {
  value = google_compute_address.static.address
}
output "network_name" {
  value = google_compute_network.petclinic-vpc-tf.self_link
}
