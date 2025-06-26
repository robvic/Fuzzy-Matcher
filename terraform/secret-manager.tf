resource "google_secret_manager_secret" "dataform_git_token" {
  provider  = google-beta
  project   = var.project_id
  secret_id = "git_secret_token"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "dataform_git_token_version" {
    provider = google-beta
    secret   = google_secret_manager_secret.dataform_git_token.id
    secret_data = var.git_token
}