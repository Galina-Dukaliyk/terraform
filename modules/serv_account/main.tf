resource "google_service_account" "gce_service_account" {
  account_id = var.instance_servaccount_id
}

resource "google_project_iam_member" "cloudsql_client" {
  role   = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.gce_service_account.email}"
}
