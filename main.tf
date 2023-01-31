resource "aws_iam_service_linked_role" "os" {
  count = var.create_service_linked_role ? 1 : 0

  aws_service_name = "opensearchservice.amazonaws.com"
  description      = "creates the AWSServiceRoleForAmazonOpenSearchService role"


  lifecycle {
    ignore_changes = [
      tags_all,
    ]
  }
}

resource "aws_opensearch_domain" "os" {
  domain_name    = "${local.stack}-${var.domain_name_suffix}"
  engine_version = var.engine_version

  cluster_config {
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_count   = var.dedicated_master_enabled ? var.master_node_count : null
    dedicated_master_type    = var.dedicated_master_enabled ? var.master_node_type : null

    instance_count = var.instance_count
    instance_type  = var.instance_type

    warm_enabled = var.warm_enabled
    warm_count   = var.warm_enabled ? var.warm_count : null
    warm_type    = var.warm_enabled ? var.warm_type : null

    cold_storage_options {
      enabled = var.cold_storage_enabled
    }

    zone_awareness_enabled = var.zone_awareness_enabled

    zone_awareness_config {
      availability_zone_count = var.zone_awareness_enabled ? var.availability_zone_count : null
    }
  }

  ebs_options {
    ebs_enabled = var.ebs_options.ebs_enabled
    volume_size = var.ebs_enabled ? var.ebs_volume_size : null
    iops        = var.ebs_enabled ? var.ebs_iops : null
    volume_type = var.ebs_enabled ? var.ebs_volume_type : null
    throughput  = var.ebs_enabled ? var.ebs_throughput : null
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  snapshot_options {
    automated_snapshot_start_hour = var.automated_snapshot_start_hour
  }

  domain_endpoint_options {
    enforce_https           = var.enforce_https
    tls_security_policy     = var.enforce_https ? "Policy-Min-TLS-1-2-2019-07" : null
    custom_endpoint_enabled = var.custom_domain_endpoint_enabled
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  log_publishing_options {
    enabled                  = var.enable_os_index_slow_logs
    cloudwatch_log_group_arn = var.index_slow_logs_cloudwatch_log_group
    log_type                 = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    enabled                  = var.enable_os_search_slow_logs
    cloudwatch_log_group_arn = var.search_slow_logs_cloudwatch_log_group
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    enabled                  = var.enable_os_application_logs
    cloudwatch_log_group_arn = var.error_logs_cloudwatch_log_group
    log_type                 = "ES_APPLICATION_LOGS"
  }

  log_publishing_options {
    enabled                  = var.enable_audit_logs
    cloudwatch_log_group_arn = var.audit_logs_cloudwatch_log_group
    log_type                 = "AUDIT_LOGS"
  }
}
