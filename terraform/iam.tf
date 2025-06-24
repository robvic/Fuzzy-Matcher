resource "google_service_account" "dataform_sa" {
  account_id   = "dataform-sa"
  display_name = "Dataform Service Account"
}

resource "google_secret_manager_secret_iam_member" "dataform_access" {
  secret_id = google_secret_manager_secret.dataform_git_token.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.dataform_sa.email}"
}