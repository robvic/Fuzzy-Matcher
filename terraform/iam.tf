resource "google_service_account" "dataform_sa" {
  account_id   = "dataform-sa"
  display_name = "Dataform Service Account"
}

resource "google_service_account" "bqowner" {
  account_id   = "bqowner"
  display_name = "BigQuery Service Account"
}

resource "google_project_iam_member" "bqowner_bigquery_admin" {
  project = var.project_id
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.bqowner.email}"
}

resource "google_project_iam_member" "bqowner_bigquery_dataeditor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.bqowner.email}"
}

resource "google_secret_manager_secret_iam_member" "dataform_access" {
  secret_id = google_secret_manager_secret.dataform_git_token.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.dataform_sa.email}"
}