

# print default org moid
output "org_ofl_moid" {
    #value = data.intersight_organization_organization.ofl.moid
    value = local.org_moid
    description = "moid of target Organization in Intersight"
}

output "ofl_pod1_ip_pool_moid" {
    value = module.imm_pool_mod.ip_pool_moid
    description = "This is the moid of the Pod wide IP_Pool for KVM & Chassis in-band IP's"
}

output "pod_id" {
    value = local.pod_id
    description = "Pod ID is used in all identifiers: MAC, WWNN, WWPN, UUID"
}

