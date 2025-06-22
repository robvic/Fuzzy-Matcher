resource "google_bigquery_dataset" "main" {
  dataset_id                  = "main"
  friendly_name               = "main"
  description                 = "Main pipeline tables, including output."
  location                    = "US"
  default_table_expiration_ms = 3600000

  labels = {
    env = "dev"
  }

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bqowner.email
  }
}

resource "google_bigquery_dataset" "aux" {
  dataset_id                  = "aux"
  friendly_name               = "aux"
  description                 = "Auxiliary tables used on pipeline transformations."
  location                    = "US"
  default_table_expiration_ms = 3600000

  labels = {
    env = "dev"
  }

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bqowner.email
  }
}

resource "google_bigquery_table" "blacklist_table" {
  dataset_id = google_bigquery_dataset.aux.dataset_id
  table_id   = "blacklist"

  labels = {
    env = "dev"
  }

  schema = <<EOF
[
  {
    "name": "term",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Term to be blacklisted on main pipeline tokens."
  }
]
EOF

}
