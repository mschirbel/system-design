include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  account_vars = find_in_parent_folders("account.hcl")
  env_vars     = find_in_parent_folders("env.hcl")
  secret_vars  = yamldecode(sops_decrypt_file(find_in_parent_folders("secrets.yaml")))
}

terraform {
  source = "terraform-aws-modules/rds/aws//modules/db_instance//v2.0"
}

inputs = {
  db_instance_class = "db.t3.micro"
  engine            = "mysql"
  engine_version    = "8.0"
  allocated_storage = 20
  storage_type      = "gp2"

  # You can adjust these according to your needs
  db_name           = local.secret_vars.db_name
  username          = local.secret_vars.username
  password          = local.secret_vars.password

  # VPC and subnet settings
  vpc_security_group_ids = local.env_vars.vpc_security_group_ids
  db_subnet_group_name   = local.env_vars.db_subnet_group_name
  multi_az               = false
  publicly_accessible    = false
  deletion_protection    = true

  tags = {
    Name        = "MyRDSInstance"
    Environment = local.env_vars.environment
  }
}
