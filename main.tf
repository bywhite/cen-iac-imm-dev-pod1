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

data "intersight_organization_organization" "ofl" {
    name = "ofl"
}
# print default org moid
output "org_ofl_moid" {
    value = data.intersight_organization_organization.ofl.moid
}
