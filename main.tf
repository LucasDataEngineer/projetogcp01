module "bigquery-dataset-combustivel" {
  source  = "./modules/bigquery"
  dataset_id                  = "combustivel_brasil"
  dataset_name                = "combustivel_brasil"
  description                 = "Dataset a respeito do histórico de preços da Gasolina no Brasil"
  project_id                  = var.project_id
  location                    = var.region
  delete_contents_on_destroy  = true
  deletion_protection = false
  access = [
    {
      role = "OWNER"
      special_group = "projectOwners"
    },
    {
      role = "READER"
      special_group = "projectReaders"
    },
    {
      role = "WRITER"
      special_group = "projectWriters"
    }
  ]
  tables=[
    {
        table_id           = "tb_historico_combustivel_brasil",
        description        = "Tabela com as informacoes de preço do combustível ao longo dos anos"
        time_partitioning  = {
          type                     = "DAY",
          field                    = "data",
          require_partition_filter = false,
          expiration_ms            = null
        },
        range_partitioning = null,
        expiration_time = null,
        clustering      = ["produto","regiao_sigla", "estado_sigla"],
        labels          = {
          name    = "project10_data_pipeline"
          project  = "combustivel"
        },
        deletion_protection = true
        schema = file("./bigquery/schema/combustivel_brasil/tb_historico_combustivel_brasil.json")
    }
  ]
}

module "bucket-raw" {
  source  = "./modules/gcs"

  name       = "bucket-project10-data-pipeline-combustiveis-brasil-raw"
  project_id = var.project_id
  location   = var.region
}

module "bucket-curated" {
  source  = "./modules/gcs"

  name       = "bucket-project10-data-pipeline-combustiveis-brasil-curated"
  project_id = var.project_id
  location   = var.region
}

module "bucket-pyspark-tmp" {
  source  = "./modules/gcs"

  name       = "bucket-project10-data-pipeline-combustiveis-brasil-pyspark-tmp"
  project_id = var.project_id
  location   = var.region
}

module "bucket-pyspark-code" {
  source  = "./modules/gcs"

  name       = "bucket-project10-data-pipeline-combustiveis-brasil-pyspark-code"
  project_id = var.project_id
  location   = var.region
}