terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}
provider "google" {
  project = "gcp-2021-2-phase2-dykaliuk"
  region  = "europe-west1"
}
