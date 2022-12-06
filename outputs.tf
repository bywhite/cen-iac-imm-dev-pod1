

# print default org moid
output "org_ofl_moid" {
    #value = data.intersight_organization_organization.ofl.moid
    value = local.org_moid
    description = "moid of target Organization in Intersight"
}

output "pod_id" {
    value = local.pod_id
    description = "Pod ID is used in all identifiers: MAC, WWNN, WWPN, UUID"
}


output "ofl_pod1_ip_pool_moid" {
    value = module.imm_pool_mod.ip_pool_moid
    description = "This is the moid of the Pod wide IP_Pool for server IMC Access IP's"
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