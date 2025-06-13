variable "credentials" {
  description = "My credentials file"
  default     = "keys/my-free-tier-8-6-36ec363c5b4c.json"
}

variable "project" {
  description = "Project"
  default     = "my-free-tier-8-6"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}

variable "location" {
  description = "Project location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "The name of the BigQuery dataset to create."
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "my bucket storage name"
  default     = "my-free-tier-8-6-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}