resource "google_storage_bucket" "data" {
  name          = "data-${var.project_id}"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }

  lifecycle {
    prevent_destroy = false
  }

  labels = {
    env = var.env
  }
}