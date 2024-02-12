variable "prefix_length" {
  type    = number
  default = 8
}

variable "function_name" {
  type        = string
  default     = ""
  description = "A user-defined name of the function"
}


variable "function_location" {
  type        = string
  default     = "US"
  description = "The location of this cloud function"
}

variable "function_description" {
  type        = string
  default     = "Gen2 function created by terraform"
  description = "A user-defined description of the function"
}

variable "function_runtime" {
  type        = string
  default     = "nodejs16"
  description = "The runtime in which to run the function."
}

variable "function_entrypoint" {
  type        = string
  default     = ""
  description = "The name of the function (as defined in source code) that will be executed. Defaults to the resource name suffix, if not specified"
}

variable "buid_environment_variables" {
  type        = map(string)
  default     = null
  description = "User-provided build-time environment variables"
}

variable "project_id" {
  type        = string
  default     = null
  description = "Project ID to create Cloud Function"
}

variable "repo_name" {
  type    = string
  default = null
}

variable "branch_name" {
  type    = string
  default = null
}

variable "tag_name" {
  type    = string
  default = null
}

variable "commit_sha" {
  type    = string
  default = null
}

variable "dir" {
  type    = string
  default = null
}

variable "function_gcs_repo_name" {
  type        = string
  default     = null
  description = "Get the source from this location in Google Cloud Storage"
}

variable "function_local_source_path" {
  type        = string
  default     = null
  description = "local path for the function boilerplate code"
}

variable "labels" {
  type = map(string)
  default = null
  description = "A set of key/value label pairs associated with this Cloud Function."
}

variable "pubsub_event_trigger" {
  type = object({
    pubsub_enabled = bool
    pubsub_config = object({
      trigger_region        = string
      event_type            = string
      pubsub_topic          = string
      retry_policy          = string
      service_account_email = string
    })
  })
  default = {
    pubsub_enabled = false
    pubsub_config = {
      trigger_region        = "us-central1"
      event_type            = "google.cloud.pubsub.topic.v1.messagePublished"
      pubsub_topic          = "topic_id"
      retry_policy          = "RETRY_POLICY_RETRY"
      service_account_email = null
    }
  }
}

variable "service_config" {
  type = object({
    max_instance_count               = number
    min_instance_count               = number
    available_memory                 = string
    timeout_seconds                  = number
    max_instance_request_concurrency = number
    available_cpu                    = string
    environment_variables            = map(string)
    vpc_connector                    = string
    ingress_settings                 = string
    all_traffic_on_latest_revision   = bool
    service_account_email            = string
    vpc_connector_egress_settings    = string
  })

  default = {
    max_instance_count               = 3
    min_instance_count               = 1
    available_memory                 = "4Gi"
    timeout_seconds                  = 60
    max_instance_request_concurrency = 80
    available_cpu                    = "4"
    environment_variables            = null
    vpc_connector                    = null
    ingress_settings                 = "ALLOW_INTERNAL_ONLY"
    all_traffic_on_latest_revision   = true
    service_account_email            = null #service account used by event arc to trigger cloud function --> this service account require permission to invoke cloud function
    vpc_connector_egress_settings    = "PRIVATE_RANGES_ONLY"
  }
}
