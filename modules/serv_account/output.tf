output "gce_inctance_service_account" {
  value = google_service_account.gce_service_account.email
}
