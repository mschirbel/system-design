include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  account_vars = find_in_parent_folders("account.hcl")
  env_vars = find_in_parent_folders("env.hcl")
}

terraform {
  source = "terraform-aws-modules/wafv2/aws"
}

inputs = {
  name        = "my-web-acl"
  description = "A simple WAF setup to protect the application"

  default_action = {
    allow {}
  }

  rules = [
    {
      name     = "AllowSpecificIP"
      priority = 1
      action   = { allow = {} }
      statement = {
        ip_set_reference_statement = {
          arn = "arn:aws:wafv2:REGION:ACCOUNT_ID:regional/ipset/my-ip-set"
        }
      }
      visibility_config = {
        sampled_requests_enabled = true
        cloudwatch_metrics_enabled = true
        metric_name = "AllowSpecificIP"
      }
    }
  ]

  scope = "REGIONAL"

  tags = {
    Environment = "dev"
  }
}
