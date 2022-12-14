# # =============================================================================
# # This defines a single Server Profile Template using a remote module
# # Builds: Server Profile Template and spawns Server Profiles
# # Each server profile template will have its own creation file (like this one).
# # -----------------------------------------------------------------------------


module "imm_pod_srv1" {
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
  server_policy_prefix = "ofl-dev-pod1-srv1"
  description   = "built by Terraform cen-iac-imm-dev-pod1 code"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "ofl-dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "ofl-dev-pod1" }
  ]

# Pass pools created by pod for servers
  mac_pool_moid     = module.imm_pool_mod.mac_pool_moid
  imc_ip_pool_moid  = module.imm_pool_mod.ip_pool_moid
  wwnn_pool_moid    = module.imm_pool_mod.wwnn_pool_moid
  wwpn_pool_a_moid  = module.imm_pool_mod.wwpn_pool_a_moid
  wwpn_pool_b_moid  = module.imm_pool_mod.wwpn_pool_b_moid
  server_uuid_pool_moid    = module.imm_pool_mod.uuid_pool_moid
  server_uuid_pool_name    = module.imm_pool_mod.uuid_pool_name

# Number of servers to create from template
  server_count = 4

# Define port names and their vlan assignments - dependent on target IMM Domain Eth-VLAN Uplinks
  server_nic_vlans = [
    { "eth0" : "42", "native" : "42" },
    { "eth1" : "42", "native" : "42" },
    { "eth2" : "42,43,1000-1001", "native" : "" },
    { "eth3" : "42,43,1000-1001", "native" : "" }
  ]

  imc_access_vlan    = 999
  server_imc_admin_password = "Cisco123"  #Recommend adding var to TFCB Workspace

 # SNMP variables
  snmp_ip       = "127.0.0.1"
  snmp_password = "Cisco123"              #Recommend adding var to TFCB Workspace
  
# SysLog
  syslog_remote_ip = "127.0.0.1"
  
# The Pools for the Pod must be created before this domain fabric module executes
  depends_on = [
    module.imm_pool_mod
]

}