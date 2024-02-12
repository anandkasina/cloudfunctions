output "function_metadata" {
  value       = { uri = google_cloudfunctions2_function.function.service_config[0].uri }
  description = "Details of the cloud function deployed"
}
#updated for testing
output "function_out" {
  value       = google_cloudfunctions2_function.function.service_config[0]
  description = "Details of the cloud function deployed"
}
