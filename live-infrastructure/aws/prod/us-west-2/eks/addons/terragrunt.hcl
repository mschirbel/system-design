include "root" {
  path   = find_in_parent_folders()
  expose = true
}

locals {
  account_vars = find_in_parent_folders("account.hcl")
  env_vars = find_in_parent_folders("env.hcl")
}

terraform {
  source = "aws-ia/eks-blueprints-addons/aws"
}

dependency "eks" {
    config_path = "../cluster/"
}

inputs = {
    cluster_name      = dependency.eks.outputs.cluster_name
    cluster_endpoint  = dependency.eks.outputs.cluster_endpoint
    cluster_version   = dependency.eks.outputs.cluster_version
    oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn

    eks_addons = {
        aws-ebs-csi-driver = {
            most_recent = true
        }
        coredns = {
            most_recent = true
        }
        vpc-cni = {
            most_recent = true
        }
        kube-proxy = {
            most_recent = true
        }
    }

    enable_aws_load_balancer_controller    = true
    enable_cluster_proportional_autoscaler = true
    enable_karpenter                       = true
    enable_kube_prometheus_stack           = true
    enable_metrics_server                  = true
    enable_external_dns                    = true
    enable_cert_manager                    = true
    enable_argo_rollouts                   = true
    enable_argo_workflows                  = true
    enable_argocd                          = true
    enable_argo_events                     = true

    tags = {
        Environment = "prod"
    }
}