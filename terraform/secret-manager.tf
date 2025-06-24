resource "google_secret_manager_secret" "secret" {
  provider  = google-beta
  secret_id = "my_secret"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
    provider = google-beta
    secret   = google_secret_manager_secret.secret.id

    secret_data = var.git_token
}