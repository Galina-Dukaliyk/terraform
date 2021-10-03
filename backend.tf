terraform {
  backend "gcs" {
    bucket = "terraform-state-dykaliuk"
    prefix = "terraform/state"
  }
}
