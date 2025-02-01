include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  account_vars = find_in_parent_folders("account.hcl")
  env_vars = find_in_parent_folders("env.hcl")
}

terraform {
  source = "tfr:///terraform-aws-modules/redshift/aws?ref=v3.2.0"
}

inputs = {
  cluster_identifier = "my-redshift-cluster"
  database_name      = local.secret_vars.database_name
  master_username    = local.secret_vars.master_username
  master_password    = local.secret_vars.master_password
  node_type          = "dc2.large"
  cluster_type       = "single-node"

  # Security and networking
  vpc_security_group_ids = ["sg-0123456789abcdef0"]
  subnet_ids             = ["subnet-0123456789abcdef0", "subnet-abcdef0123456789"]

  # Logging
  enable_logging = true
  bucket_name    = "my-redshift-logs"
}

