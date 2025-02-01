include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  account_vars = find_in_parent_folders("account.hcl")
  env_vars = find_in_parent_folders("env.hcl")
}

terraform {
  source = "terraform-aws-modules/eks/aws//"
}

inputs = {
  cluster_name    = "my-cluster"
  cluster_version = "1.31"

  vpc_id          = "vpc-xxxxxx"
  subnet_ids      = ["subnet-xxxxxx", "subnet-yyyyyy"]

  node_group_name = "my-node-group"
  node_group_desired_capacity = 2
  node_group_max_capacity     = 3
  node_group_min_capacity     = 1

  node_group_instance_type = "t3.medium"
  node_group_ami_type      = "AL2_x86_64"

  cluster_iam_role_name = "my-cluster-iam-role"
  node_group_iam_role_name = "my-node-group-iam-role"

  # Enable logging for the cluster
  enable_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  tags = {
    Environment = "prod"
    ManagedBy   = "Terragrunt"
  }
}
