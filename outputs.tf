# Output as needed to reveal Objects created

output "pod_id" {
    value = local.pod_id
    description = "Pod ID is used in all identifiers: MAC, WWNN, WWPN, UUID"
}

# print default org moid
output "org_ofl_moid" {
    #value = data.intersight_organization_organization.ofl.moid
    value = local.org_moid
    description = "moid of target Organization in Intersight"
}

output "domain_vmw_1_name" {
    value = module.intersight_policy_bundle_vmw_1.fi6536_cluster_profile_name
    description = "UCS Domain VMW-1 object name"
}
output "domain_vmw_1_moid" {
    value = module.intersight_policy_bundle_vmw_1.fi6536_cluster_profile_moid
    description = "UCS Domain VMW-1 moid"
}

output "vmw_1_chassis_9508_profiles" {
    value = module.intersight_policy_bundle_vmw_1.chassis_9508_profiles
}

output "ofl_pod1_ip_pool_chassis_moid" {
    value = module.imm_pool_mod.ip_pool_chassis_moid
    description = "This is the moid of the Pod wide IP_Pool for Chassis in-band IP's"
}

output "ofl_pod1_mac_pool_moid" {
    value = module.imm_pool_mod.mac_pool_moid
    description = "This is the moid of the Pod wide Mac_Pool for vNic's"
}

output "ofl_pod1_wwnn_pool_moid" {
    value = module.imm_pool_mod.wwnn_pool_moid
    description = "This is the moid of the WWNN pool for HBA's"
}

output "ofl_pod1_wwpn_pool_a_moid" {
    value = module.imm_pool_mod.wwpn_pool_a_moid
}

output "ofl_pod1_wwpn_pool_b_moid" {
    value = module.imm_pool_mod.wwpn_pool_b_moid
}

output "ofl_pod1_uuid_pool_moid" {
    value = module.imm_pool_mod.uuid_pool_moid
}