# # =============================================================================
# # This defines a single Server Profile Template using a remote module
# # Builds: Server Profile Template and associated Server Resource Pool
# # Creates: Server Profiles by "Count" ("Resource Pool" not enabled yet)
# # To Duplicate Template:
# #    * Change module: "server_template_vmwX"  >> "server_template_vmwY"
# #    * Change server_policy_prefix: "ofl-dev-pod1-vmwX" > "ofl-dev-pod1-vmwY"
# #    * Change Tag value for "ServerGroup" to include new name
# # -----------------------------------------------------------------------------


module "server_template_vmw1" {                      # <<-- Change to duplicate
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/imm-pod-servers"
            # remote module name above should not be changed when duplicating

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------
  # external sources
  organization    = data.intersight_organization_organization.ofl.id

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # prefix for all created policies
  server_policy_prefix = "ofl-dev-pod1-vmw1"         # <<-- Change to duplicate
  description   = "built by Terraform cen-iac-imm-dev-pod1 derived"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "ofl-dev-pod1" },
    { "key" : "ServerGroup", "value" : "ofl-dev-pod1-vmw1-srvgroup" } # <-- Change
  ]

# =============================================================================
# Pod-wide pools
# -----------------------------------------------------------------------------

  mac_pool_moid     = module.imm_pool_mod.mac_pool_moid
  imc_ip_pool_moid  = module.imm_pool_mod.ip_pool_moid
  wwnn_pool_moid    = module.imm_pool_mod.wwnn_pool_moid
  wwpn_pool_a_moid  = module.imm_pool_mod.wwpn_pool_a_moid
  wwpn_pool_b_moid  = module.imm_pool_mod.wwpn_pool_b_moid
  server_uuid_pool_moid    = module.imm_pool_mod.uuid_pool_moid
  server_uuid_pool_name    = module.imm_pool_mod.uuid_pool_name

# =============================================================================
# Server vNic Configurations & FC SAN HBA's
# -----------------------------------------------------------------------------

  vnic_vlan_sets = {
    "eth0"  = {
      vnic_name  = "eth0"
      native_vlan = 45
      vlan_range  = "45"
      switch_id   = "A"
      pci_order   = 0
    }
    "eth1"  = {
      vnic_name   = "eth1"
      native_vlan = 45
      vlan_range  = "45"
      switch_id   = "B"
      pci_order   = 1
    }
  }


  vhba_vsan_sets = {
    "fc0" = {
      vhba_name      = "fc0"
      vsan_id        = 100
      switch_id      = "A"
      wwpn_pool_moid = module.imm_pool_mod.wwpn_pool_a_moid
      pci_order      = 2
    }
    "fc1"  = {
      vhba_name      = "fc1"
      vsan_id        = 200
      switch_id      = "B"
      wwpn_pool_moid = module.imm_pool_mod.wwpn_pool_b_moid
      pci_order      = 3
    }
    "fc2" = {
      vhba_name      = "fc0"
      vsan_id        = 300
      switch_id      = "A"
      wwpn_pool_moid = module.imm_pool_mod.wwpn_pool_a_moid
      pci_order      = 4
    }
    "fc3"  = {
      vhba_name      = "fc1"
      vsan_id        = 400
      switch_id      = "B"
      wwpn_pool_moid = module.imm_pool_mod.wwpn_pool_b_moid
      pci_order      = 5
    }
  }

 
# =============================================================================
# Server monitoring configurations
# -----------------------------------------------------------------------------

 # SNMP
  snmp_ip       = "127.0.0.1"
  snmp_password = "Cisco123"              #Recommend adding var to TFCB Workspace
  
  # SysLog 
  syslog_remote_ip = "127.0.0.1"

# =============================================================================
# Local IMC Users - defined pod wide
# -----------------------------------------------------------------------------
  # Sets local users and their permissions and passwords
  user_policy_moid          = intersight_iam_end_point_user_policy.pod_user_policy_1.moid
  imc_access_vlan           = 999
  server_imc_admin_password = "Cisco123"  #Recommend adding var to TFCB Workspace


# =============================================================================
# Dependencies
# -----------------------------------------------------------------------------
# The Pools for the Pod must be created before this domain fabric module executes
  depends_on = [
    module.imm_pool_mod, intersight_iam_end_point_user_policy.pod_user_policy_1
  ]

}