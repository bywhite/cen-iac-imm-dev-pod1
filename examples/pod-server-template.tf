# # =============================================================================
# # This defines a single Server Profile Template using a remote module
# # Builds: Server Profile Template and associated Server Resource Pool
# #    * Note: Derivation of Server Profiles is outside of TF scope
# # Duplicate this code/file to add another new Server Template and:
# #    * Change module: "server_template_vmwX"  >> "server_template_vmwY"
# #    * Change server_policy_prefix: "...-vmwX" > "...-vmwY"
# #    * Change Tag value for "ServerGroup" to include new name
# #    * Modify parameters as needed to tweak your template configuration
# # -----------------------------------------------------------------------------


module "server_template_vmw1" {                                   # <<-- Change to duplicate
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods//imm-pod-servers"
            # remote module name above should not be changed when duplicating

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------
  # external sources
  organization    = local.org_moid

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # prefix for all created policies
  server_policy_prefix = "${local.pod_policy_prefix}-vmw1"         # <<-- Change to duplicate
  description   = "built by Terraform ${local.pod_policy_prefix}"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "${local.pod_policy_prefix}" },
    { "key" : "ServerGroup", "value" : "${local.pod_policy_prefix}-vmw1-srvgroup" } # <-- Change to duplicate
  ]

# =============================================================================
# X vs B Chassis Profile Customizations
# -----------------------------------------------------------------------------
# Customize policies for X-Series (true) or B-Series (false)
  is_x_series_profile = true 

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
# Server Eth vNic's & FC vHBA's
# -----------------------------------------------------------------------------
# Ensure "pci_order is unique and sequential across all vnic/vhba"
# Ensure vlans & vsans are provisioned on target UCS Domain, use depends_on

  vnic_vlan_sets = {
    "eth0"  = {
      vnic_name  = "eth0"
      native_vlan = 21
      vlan_range  = "21,60,254,255"
      switch_id   = "A"
      pci_order   = 0
      qos_moid    = module.imm_pod_qos_mod.vnic_qos_besteffort_moid
    }
    "eth1"  = {
      vnic_name   = "eth1"
      native_vlan = 21
      vlan_range  = "21,60,254,255"
      switch_id   = "B"
      pci_order   = 1
      qos_moid    = module.imm_pod_qos_mod.vnic_qos_besteffort_moid
    }
  }


  vhba_vsan_sets = {
    "fc0" = {
      vhba_name      = "fc0"
      vsan_moid      = module.pod_vsan_policy_1.fc_vsan_101_moid
      switch_id      = "A"
      wwpn_pool_moid = module.imm_pool_mod.wwpn_pool_a_moid
      pci_order      = 2
      qos_moid       = module.imm_pod_qos_mod.vnic_qos_fc_moid
    }
    "fc1"  = {
      vhba_name      = "fc1"
      vsan_moid      = module.pod_vsan_policy_1.fc_vsan_102_moid
      switch_id      = "B"
      wwpn_pool_moid = module.imm_pool_mod.wwpn_pool_b_moid
      pci_order      = 3
      qos_moid       = module.imm_pod_qos_mod.vnic_qos_fc_moid
    }
  }

 
# =============================================================================
# Server monitoring configurations
# -----------------------------------------------------------------------------
# All values could be set with Local's or Variables

 # SNMP
  snmp_ip       = "10.10.10.10"
  snmp_password = "Cisco123"              #Recommend adding var to TFCB Workspace
  
  # SysLog 
  syslog_remote_ip = "10.10.10.10"

# =============================================================================
# Local IMC Users - defined pod wide
# -----------------------------------------------------------------------------
  # Sets local users and their permissions and passwords
  user_policy_moid          = local.iam_user_policy_moid
  imc_access_vlan           = 21
  server_imc_admin_password = "C1sc0123!"  #Recommend adding var to TFCB Workspace


# =============================================================================
# Dependencies
# -----------------------------------------------------------------------------
# The Pools for the Pod must be created before this domain fabric module executes
  depends_on = [
    module.imm_pool_mod, module.pod_user_policy_1,
    module.imm_pod_qos_mod, module.intersight_pod2_domain_1,
    intersight_vnic_fc_network_policy.fc_vsan_100, intersight_vnic_fc_network_policy.fc_vsan_200
  ]

}