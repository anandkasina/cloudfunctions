
resource "random_id" "function_prefix" {
  byte_length = var.prefix_length
}
# TO DO : needs to be updated
resource "google_storage_bucket_object" "object" {
  name   = "${var.function_name}/${var.function_name}.zip"
  bucket = var.function_gcs_repo_name
  source = var.function_local_source_path # Add path to the zipped function source code to be stored in a bkt
}

resource "google_cloudfunctions2_function" "function" {
  project     = var.project_id
  name        = var.function_name != "" ? var.function_name : "${random_id.function_prefix.hex}-gen2-"
  location    = var.function_location
  description = var.function_description
  labels      = var.labels

  build_config {
    runtime               = var.function_runtime
    entry_point           = var.function_entrypoint # Set the entry point 
    environment_variables = var.buid_environment_variables
    source {
      storage_source {
        bucket = var.function_gcs_repo_name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count               = var.service_config.max_instance_count
    min_instance_count               = var.service_config.min_instance_count
    available_memory                 = var.service_config.available_memory
    timeout_seconds                  = var.service_config.timeout_seconds
    max_instance_request_concurrency = var.service_config.max_instance_request_concurrency
    available_cpu                    = var.service_config.available_cpu
    vpc_connector                    = var.service_config.vpc_connector
    environment_variables            = var.service_config.environment_variables
    ingress_settings                 = var.service_config.ingress_settings
    all_traffic_on_latest_revision   = var.service_config.all_traffic_on_latest_revision
    service_account_email            = var.service_config.service_account_email
    vpc_connector_egress_settings    = var.service_config.vpc_connector_egress_settings
  }

  dynamic "event_trigger" {
    for_each = var.pubsub_event_trigger["pubsub_enabled"] == true ? [1] : []
    content {
      trigger_region        = var.pubsub_event_trigger["pubsub_config"]["trigger_region"]
      event_type            = var.pubsub_event_trigger["pubsub_config"]["event_type"]
      pubsub_topic          = var.pubsub_event_trigger["pubsub_config"]["pubsub_topic"]
      retry_policy          = var.pubsub_event_trigger["pubsub_config"]["retry_policy"]
      service_account_email = var.pubsub_event_trigger["pubsub_config"]["service_account_email"]
    }
  }
}
