 resource "google_dataform_repository" "dataform_repository" {
   project = var.project_id
   provider = google-beta
   name = "dataform-${var.solution}"
   region = var.region
   service_account = google_service_account.dataform_sa.email
   timeouts {}

   git_remote_settings {
       url = var.git-repository
       default_branch = var.branch
       authentication_token_secret_version = "projects/${var.project_id}/secrets/${google_secret_manager_secret.dataform_git_token.secret_id}/versions/latest"
   }

   workspace_compilation_overrides {
     schema_suffix = var.branch
     default_database = var.project_id
   }

   depends_on = [
    google_secret_manager_secret.dataform_git_token,
    google_secret_manager_secret_version.dataform_git_token_version,
    google_secret_manager_secret_iam_member.dataform_access,
    google_service_account.dataform_sa
  ]
 }

resource "google_dataform_repository_release_config" "release_config" {
  provider = google-beta

  project    = var.project_id
  region     = var.region
  repository = google_dataform_repository.dataform_repository.name

  name          = "main_release"
  git_commitish = "main"
  cron_schedule = "0 7 * * *"
  time_zone     = "America/Sao_Paulo"

  code_compilation_config {
    default_database = var.project_id
    default_schema   = "main"
    default_location = var.region
    assertion_schema = "dataform_assertions"
    database_suffix  = ""
    schema_suffix    = ""
    table_prefix     = ""
    vars = {
      var1 = "value"
    }
  }

  depends_on = [ google_bigquery_dataset.main,
                google_bigquery_dataset.dataform_assertions ]
}

resource "google_dataform_repository_workflow_config" "workflow" {
  provider = google-beta

  project        = var.project_id
  region         = var.region
  repository     = google_dataform_repository.dataform_repository.name
  name           = "my_workflow"
  release_config = google_dataform_repository_release_config.release_config.id

  invocation_config {
    included_targets {
      database = var.project_id
      schema   = "main"
      name     = "target_1"
    }
    included_tags                            = ["tag_1"]
    transitive_dependencies_included         = true
    transitive_dependents_included           = true
    fully_refresh_incremental_tables_enabled = false
    service_account                          = google_service_account.dataform_sa.email
  }

  cron_schedule   = "0 7 * * *"
  time_zone       = "America/Sao_Paulo"

  depends_on = [ google_bigquery_dataset.main,
                google_bigquery_dataset.dataform_assertions ]
}