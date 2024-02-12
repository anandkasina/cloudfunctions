// main.tf

// Configure the provider
provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}

// Include the module
module "cloud_function_example" {
  source = "C:/Users/KASINA/IdeaProjects/cloudfunctions/cloudfunctions/cloudfunctions/cloud-function"

  // Pass input variables to the module
  function_name = "example-function"
  function_gcs_repo_name = "example-bucket"
  function_local_source_path = "path/to/function/source.zip"

  // Function configuration
  function_location = "us-central1"
  function_description = "An example Cloud Function"
  function_runtime = "nodejs14"
  function_entrypoint = "handler"

  // Service config
  service_config = {
    max_instance_count = 10
    min_instance_count = 1
    available_memory = 256
    timeout_seconds = 60
    max_instance_request_concurrency = 10
    available_cpu = 1
    vpc_connector = "projects/your-project-id/locations/us-central1/connectors/your-vpc-connector-name"
    environment_variables = {
      ENV_VAR_KEY = "ENV_VAR_VALUE"
    }
    ingress_settings = "ALLOW_ALL"
    all_traffic_on_latest_revision = false
    service_account_email = "your-service-account@your-project-id.iam.gserviceaccount.com"
    vpc_connector_egress_settings = "PRIVATE_RANGES_ONLY"
  }

  // Event trigger
  pubsub_event_trigger = {
    pubsub_enabled = true
    pubsub_config = {
      trigger_region = "us-central1"
      event_type = "google.pubsub.topic.publish"
      pubsub_topic = "projects/your-project-id/topics/your-pubsub-topic"
      retry_policy = {
        retry_duration = "10s"
        minimum_backoff = "1s"
        maximum_backoff = "5s"
        maximum_retry_duration = "10m"
        initial_rpc_timeout = "120s"
        rpc_timeout_multiplier = 1.0
        retryable_statuses = ["UNAVAILABLE", "DEADLINE_EXCEEDED", "RESOURCE_EXHAUSTED"]
      }
      service_account_email = "your-service-account@your-project-id.iam.gserviceaccount.com"
    }
  }
}
