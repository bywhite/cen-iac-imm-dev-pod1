# =============================================================================
# COMMON objects shared throughout Pod for consistent configurations:
#   - IMC Local User Policies
#   - Pod Server VSAN Policies
#   - QoS Policies for Server Template vNic's
#   - Pod Pools: IP, MAC, UUID, WWNN, WWPN
# =============================================================================


# =============================================================================
# IMC Local User Policies
# -----------------------------------------------------------------------------
# Consumed by Server Profiles or Sever Templates with:
# USAGE:  module.pod_user_policy.user_policy_moid 

module "pod_user_policy_1" {
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods//imm-pod-user-mod"
  
  # external sources
  organization       = local.org_moid
  pod_policy_prefix  = local.pod_policy_prefix
  description        = "Pod User Policy 1"
  tags               = local.pod_tags
  imc_admin_password = var.imc_admin_password
}


# =============================================================================
#   - Pod Server VSAN Policies
# -----------------------------------------------------------------------------
# Consumed by Server Profiles or Sever Templates with:
# This must match up with domain fabric's (FI's) vSAN Configuration
# USAGE:
#   vsan_moid      = module.pod_vsan_policy_1.fc_vsan_100_moid
#   vsan_moid      = module.pod_vsan_policy_1.fc_vsan_101_moid
#   vsan_moid      = module.pod_vsan_policy_1.fc_vsan_102_moid
#   vsan_moid      = module.pod_vsan_policy_1.fc_vsan_200_moid
#   vsan_moid      = module.pod_vsan_policy_1.fc_vsan_201_moid
#   vsan_moid      = module.pod_vsan_policy_1.fc_vsan_202_moid


module "pod_vsan_policy_1" {
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods//imm-pod-vsan-mod"
  
  # external sources
  organization       = local.org_moid
  pod_policy_prefix  = local.pod_policy_prefix
  description        = "Pod User Policy 1"

}


# =============================================================================
# QoS Policies for Server Template vNic's
# -----------------------------------------------------------------------------
# Creates vNic QoS Policies for each active class of service (CoS)
# This must match up with domain fabric's System QoS Policy and
# match up with external network's QoS configurations
# Consumed by Server Profile Templates with:
# USAGE:  
#   qos_moid    = module.imm_pod_qos_mod.vnic_qos_besteffort_moid
#   qos_moid    = module.imm_pod_qos_mod.vnic_qos_bronze_moid
#   qos_moid    = module.imm_pod_qos_mod.vnic_qos_silver_moid
#   qos_moid    = module.imm_pod_qos_mod.vnic_qos_gold_moid
#   qos_moid    = module.imm_pod_qos_mod.vnic_qos_platinum_moid
#   qos_moid    = module.imm_pod_qos_mod.vnic_qos_fc_moid

module "imm_pod_qos_mod" {       
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods//imm-pod-server-qos-mod"

# external references
  org_id        = local.org_moid
  policy_prefix = local.pod_policy_prefix
  description   = "built by Terraform for ${local.pod_policy_prefix}"
  tags          = local.pod_tags

}

# =============================================================================
# Pod Pools: IP, MAC, UUID, WWNN, WWPN
# -----------------------------------------------------------------------------
# Creates sequential identity pools for server templates and chassis
# Consumed by Server Profiles or Sever Templates with:
# SERVER USAGE:  
  # mac_pool_moid         = module.imm_pool_mod.mac_pool_moid
  # imc_ip_pool_moid      = module.imm_pool_mod.ip_pool_moid
  # wwnn_pool_moid        = module.imm_pool_mod.wwnn_pool_moid
  # wwpn_pool_a_moid      = module.imm_pool_mod.wwpn_pool_a_moid
  # wwpn_pool_b_moid      = module.imm_pool_mod.wwpn_pool_b_moid
  # server_uuid_pool_moid = module.imm_pool_mod.uuid_pool_moid
  # server_uuid_pool_name = module.imm_pool_mod.uuid_pool_name
# CHASSIS USAGE:
  # chassis_imc_ip_pool_moid = module.imm_pool_mod.ip_pool_chassis_moid

module "imm_pool_mod" {
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods//imm-pod-pools-mod"
  
  # external sources
  organization    = local.org_moid
  policy_prefix = local.pod_policy_prefix
  pod_id = local.pod_id                   # used to create unique identity Pools: MAC, WWNN, WWPN
  description   = local.description       # Using generic pod description

# Server Inband IP Pool values for Server IMC
  ip_size     = "18"
  ip_start = "192.168.21.100"
  ip_gateway  = "192.168.21.1"
  ip_netmask  = "255.255.255.0"
  ip_primary_dns = "192.168.60.7"

# Chassis Inband IP Pool values for Chassis IMC
  chassis_ip_size     = "4"
  chassis_ip_start = "192.168.21.118"
  chassis_ip_gateway  = "192.168.21.1"
  chassis_ip_netmask  = "255.255.255.0"
  chassis_ip_primary_dns = "192.168.60.7"

  tags = local.pod_tags

}


# =============================================================================
# =============================================================================
