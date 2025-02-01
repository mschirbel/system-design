include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  account_vars = find_in_parent_folders("account.hcl")
  env_vars = find_in_parent_folders("env.hcl")
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-glue.git//?ref=v3.3.0"
}

inputs = {
  glue_jobs = [
    {
      name          = "example-glue-job"
      role_arn      = "arn:aws:iam::123456789012:role/AWSGlueServiceRole"
      command       = {
        script_location = "s3://my-glue-scripts/script.py"
        name            = "glueetl"
      }
      default_arguments = {
        "--TempDir" = "s3://my-glue-temp/"
      }
      max_retries    = 1
      timeout        = 10
      number_of_workers = 2
      worker_type    = "G.1X"
    }
  ]
}
