resource "google_compute_network" "this" {
  project                 = var.project_id
  name                    = "main-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  project       = var.project_id
  name          = "main-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "asia-northeast1"
  network       = google_compute_network.this.id
  secondary_ip_range {
    range_name    = "pod-ip-range"
    ip_cidr_range = "10.10.0.0/16"
  }
  secondary_ip_range {
    range_name    = "service-ip-range"
    ip_cidr_range = "10.20.0.0/16"
  }
}