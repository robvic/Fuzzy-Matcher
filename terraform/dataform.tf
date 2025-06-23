 resource "google_dataform_repository" "dataform_repository" {
   project = var.projeto-pipeline
   provider = google-beta
   name = "${var.solucao}${local.sufixo}"
   region = var.regiao
   timeouts {}

   git_remote_settings {
       url = var.git-repository
       default_branch = var.branch
       authentication_token_secret_version = "projects/${var.projeto-pipeline}/secrets/${var.solucao}/versions/latest"
   }

   workspace_compilation_overrides {
     schema_suffix = var.branch
     default_database = var.projeto-pipeline
   }
 }

resource "google_dataform_repository_release_config" "release" {
  provider = google-beta

  project    = google_dataform_repository.repository.project
  region     = google_dataform_repository.repository.region
  repository = google_dataform_repository.repository.name

  name          = "my_release"
  git_commitish = "main"
  cron_schedule = "0 7 * * *"
  time_zone     = "America/New_York"

  code_compilation_config {
    default_database = "gcp-example-project"
    default_schema   = "example-dataset"
    default_location = "us-central1"
    assertion_schema = "example-assertion-dataset"
    database_suffix  = ""
    schema_suffix    = ""
    table_prefix     = ""
    vars = {
      var1 = "value"
    }
  }
}

resource "google_dataform_repository_workflow_config" "workflow" {
  provider = google-beta

  project        = google_dataform_repository.repository.project
  region         = google_dataform_repository.repository.region
  repository     = google_dataform_repository.repository.name
  name           = "my_workflow"
  release_config = google_dataform_repository_release_config.release_config.id

  invocation_config {
    included_targets {
      database = "gcp-example-project"
      schema   = "example-dataset"
      name     = "target_1"
    }
    included_targets {
      database = "gcp-example-project"
      schema   = "example-dataset"
      name     = "target_2"
    }
    included_tags                            = ["tag_1"]
    transitive_dependencies_included         = true
    transitive_dependents_included           = true
    fully_refresh_incremental_tables_enabled = false
    service_account                          = google_service_account.dataform_sa.email
  }

  cron_schedule   = "0 7 * * *"
  time_zone       = "America/New_York"
}