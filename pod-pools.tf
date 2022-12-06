# Create a sequential IP pool for IMC access. Change the from and size to what you would like

# Mac uses CMD+K+C to comment out blocks.   CMD+K+U will un-comment blocks of code

# resource "intersight_ippool_pool" "ippool_podpool" {
#   name = "${local.pod_policy_prefix}-pool-ip"
#   description = "ofl Pod IP Pool for all KVM & Chassis"
#   assignment_order = "sequential"
#   ip_v4_blocks {
#     from = "10.10.10.101"
#     size = "99"
#   }
#   ip_v4_config {
#     object_type = "ippool.IpV4Config"
#     gateway = "10.10.10.1"
#     netmask = "255.255.255.0"
#     primary_dns = "8.8.8.8"
#     }
#   organization {
#       object_type = "organization.Organization"
#       moid = local.org_moid
#       }
# }

module "imm_pool_mod" {
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/pod-pools-mod"
  #source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/imm-domain-fabric-module"
  
  # external sources
  organization    = data.intersight_organization_organization.ofl.id

  # every policy created will have this prefix in its name
  policy_prefix = "dev-ofl-pod1"
  description   = "Built by Terraform repo: cen-iac-imm-dev-pod1  module: pod-pools-mod"

  ip_size     = "200"
  ip_start = "10.10.10.11"
  ip_gateway  = "10.10.10.1"
  ip_netmask  = "255.255.255.0"
  ip_primary_dns = "8.8.8.8"

  chassis_ip_size     = "150"
  chassis_ip_start = "10.10.2.11"
  chassis_ip_gateway  = "10.10.2.1"
  chassis_ip_netmask  = "255.255.255.0"
  chassis_ip_primary_dns = "8.8.8.8"

  pod_id = local.pod_id
  # used to create moids for Pools: MAC, WWNN, WWPN

  tags = [
    { "key" : "Environment", "value" : "dev-ofl" },
    { "key" : "Orchestrator", "value" : "Terraform" }
  ]
}


