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

resource "google_project_iam_member" "dataform_bigquery_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dataform_sa.email}"
}

resource "google_project_iam_member" "dataform_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.dataform_sa.email}"
}

resource "google_project_iam_member" "dataform_default_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-dataform.iam.gserviceaccount.com"
}

resource "google_secret_manager_secret_iam_member" "dataform_access" {
  project = var.project_id
  secret_id = google_secret_manager_secret.dataform_git_token.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.dataform_sa.email}"
}

resource "google_secret_manager_secret_iam_member" "dataform_default_sa_access" {
  project = var.project_id
  secret_id = google_secret_manager_secret.dataform_git_token.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:service-${var.project_number}@gcp-sa-dataform.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "dataform_sa_dataeditor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.dataform_sa.email}" 
}

resource "google_project_iam_member" "dataform_sa_object_get" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.dataform_sa.email}" 
}