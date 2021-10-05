resource "google_compute_firewall" "firewall_rule" {
  name    = var.rule_name
  network = var.network_name
  allow {
    protocol = var.protocol
    ports    = var.port
  }
  target_tags   = var.tag
  source_ranges = var.ranges_source
}
