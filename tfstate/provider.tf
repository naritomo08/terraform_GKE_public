provider "google" {
  credentials = file("../gcp.json")
  project     = "<プロジェクト名>"
  region      = "asia-northeast1"
  zone        = "asia-northeast1-a"
}
