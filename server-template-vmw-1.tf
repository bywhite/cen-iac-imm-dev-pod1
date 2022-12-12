# # =============================================================================
# # This defines a single Server Profile Template using a remote module
# # Builds: Server Profile Template and spawns Server Profiles
# # Each server profile template will have its own creation file (like this one).
# # -----------------------------------------------------------------------------



module "intersight_policy_bundle_vmw_1" {
  #source = "github.com/pl247/tf-intersight-policy-bundle"
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/imm-pod-servers-mod"

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------

  # external sources
  organization    = data.intersight_organization_organization.ofl.id

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # every policy created will have this prefix in its name
  policy_prefix = "ofl-dev-pod1-vmw1"
  description   = "built by Terraform cen-iac-imm-dev-pod1 code"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "ofl-dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "domain", "value" : "ofl-dev-pod1-vmw1" }
  ]

  ip_pool_moid     = module.imm_pool_mod.ip_pool_moid
  mac_pool_moid    = module.imm_pool_mod.mac_pool_moid
  wwnn_pool_moid   = module.imm_pool_mod.wwnn_pool_moid
  wwpn_a_pool_moid = module.imm_pool_mod.wwpn_pool_a_moid
  wwpn_b_pool_moid = module.imm_pool_mod.wwpn_pool_b_moid
  uuid_pool_moid   = module.imm_pool_mod.uuid_pool_moid

# Define port names and their vlan assignments - dependent on target IMM Domain Eth-VLAN Uplinks
  server_ports = [
    { "eth0" : "42", "native" : "42" },
    { "eth1" : "42", "native" : "42" },
    { "eth2" : "50,55,1000-1011", "native" : "" },
    { "eth3" : "50,55,1000-1011", "native" : "" }
  ]

# The Pools for the Pod must be created before this domain fabric module executes
  depends_on = [
    module.imm_pool_mod
]

}