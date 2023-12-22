
resource "google_project_service" "compute" {
  project = var.project_id
  service = "compute.googleapis.com"
  disable_dependent_services = true
}
resource "google_project_service" "container" {
  project = var.project_id
  service = "container.googleapis.com"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke_cluster.ca_certificate)
}

module "gke_cluster" {
  source     = "terraform-google-modules/kubernetes-engine/google"
  project_id = var.project_id
  
  name                        = "cluster"
  regional                    = true
  region                      = "asia-northeast1"
  network                     = google_compute_network.this.name
  subnetwork                  = google_compute_subnetwork.this.name
  ip_range_pods               = "pod-ip-range"
  ip_range_services           = "service-ip-range"
  create_service_account      = true
  enable_cost_allocation      = true
  enable_binary_authorization = false
  gcs_fuse_csi_driver         = true
  deletion_protection         = false

  depends_on = [
    google_project_service.compute,
    google_project_service.container,
  ]
}