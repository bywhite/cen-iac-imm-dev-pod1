
output "ofl_pod1_ip_pool_moid" {
    value = module.imm_pool_mod.ip_pool_moid
    description = "This is the moid of the Pod wide IP_Pool for KVM & Chassis in-band IP's"
}

