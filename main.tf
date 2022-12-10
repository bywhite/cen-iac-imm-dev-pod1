terraform {

  backend "remote" {
    organization = "bywhite"

    workspaces {
      name = "cen-iac-imm-dev-pod1"
    }
  }

    required_providers {
        intersight = {
            source = "CiscoDevNet/intersight"
            version = ">=1.0.20"
        }
    }
}

provider "intersight" {
    apikey = var.api_key
    secretkey = var.secretkey
    endpoint = var.endpoint
}

#Organizations should be created manually in Intersight and changed below for each Data Center
data "intersight_organization_organization" "ofl" {
    name = "ofl"
}

# IMM Code Examples Can Be Found at:
# https://github.com/terraform-cisco-modules/terraform-intersight-imm/tree/master/modules