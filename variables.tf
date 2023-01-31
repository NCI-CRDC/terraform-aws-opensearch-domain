variable "app" {
  type        = string
  description = "the name of the application expressed as an acronym"
  sensitive   = false
}

variable "env" {
  type        = string
  description = "the target tier ('dev', 'qa', 'stage', or 'prod'.)"
  sensitive   = false

  validation {
    condition     = contains(["dev", "qa", "stage", "prod", "nonprod"], var.env)
    error_message = "valid values are 'dev', 'qa', 'stage', 'prod', and 'nonprod'"
  }
}

variable "program" {
  type        = string
  description = "the program associated with the application"
  sensitive   = false

  validation {
    condition     = contains(["crdc", "ccdi", "ctos"], var.program)
    error_message = "valid values for program are 'crdc', 'ccdi', and 'ctos'"
  }
}

variable "availability_zone_count" {
  type        = number
  description = "number of availability zones for the domain to use"
}

variable "domain_name_suffix" {
  type        = string
  description = "the domain name suffix that follows the stack name"
  default     = "opensearch"
}

variable "engine_version" {
  type        = string
  description = "the opensearch engine version"
}


variable "ebs_enabled" {
  type        = bool
  description = "whether to attach ebs volumes to the domain"
  default     = true
}

variable "ebs_iops" {
  type        = number
  description = "baseline input/output (I/O) performance of the ebs volumes attached to each node"
  default     = 3000
}

variable "ebs_throughput" {
  type        = number
  description = "throughput (MiB) of the ebs volumes - valid range between 125 and 1000"
  default     = 125
}

variable "ebs_volume_size" {
  type        = number
  description = "size of the volumes attached to each node (GB)"
  default     = 10
}

variable "ebs_volume_type" {
  type        = string
  description = "type of ebs volumes"
  default     = "gp3"
}

variable "zone_awareness_enabled" {
  type        = bool
  description = "enable multi-availability zone deployments"
}