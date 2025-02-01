include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  account_vars = find_in_parent_folders("account.hcl")
  env_vars = find_in_parent_folders("env.hcl")
}

terraform {
  source = "terraform-aws-modules/sqs/aws"
}

inputs = {
  name = "my-queue"

  delay_seconds            = 5
  max_message_size         = 262144
  message_retention_seconds = 86400
  receive_message_wait_time_seconds = 20

  visibility_timeout_seconds = 30

  tags = {
    Environment = "dev"
    ManagedBy   = "Terragrunt"
  }
}
