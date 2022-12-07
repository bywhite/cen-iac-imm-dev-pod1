# This defines the desired configuration of the dev-ofl-pod1-vmw-1 IMM domain
# Modules are used with supplied values to define the desired configuration of the domain infrastructure


module "intersight_policy_bundle_vmw_1" {
  #source = "github.com/pl247/tf-intersight-policy-bundle"
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/imm-domain-fabric-6536"
  # external sources
  organization    = data.intersight_organization_organization.ofl.id

  # every policy created will have this prefix in its name
  policy_prefix = "dev-ofl-pod1-vmw1"
  description   = "Built by Terraform cen-iac-imm-dev-pod1 code"

 # Fabric Interconnect 6536 config specifics
  server_ports_6536 = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
  port_channel_6536 = [31, 32, 33, 34]
  uplink_vlans_6536 = {
    "vlan-998" : 998,
    "vlan-999" : 999
  }
  fc_port_count_6536 = 2
     #For each port_count physical port above, it is broken-out into 4x 32G FC Ports
     #A value of 2 results in 8x 32G FC Port breakouts from ports 35 & 36
     # Unified Ports 33-36 (FC ports on right of the slider starting with 36)

  imc_access_vlan    = 999
  imc_admin_password = "Cisco123"
  imc_ip_pool_moid = module.imm_pool_mod.ip_pool_moid

  chassis_imc_access_vlan    = 999
  chassis_imc_ip_pool_moid = module.imm_pool_mod.ip_pool_moid
  #Need to create separate IP Pool for Chassis

  ntp_servers = ["ca.pool.ntp.org"]

  dns_preferred = "172.22.16.254"
  dns_alternate = "172.22.16.253"

  ntp_timezone = "America/Chicago"

# starting values for wwnn, wwpn-a/b and mac pools (size 255)
  # wwnn-block   = "20:00:00:CA:FE:00:00:01"
  # wwpn-a-block = "20:00:00:CA:FE:0A:00:01"
  # wwpn-b-block = "20:00:00:CA:FE:0B:00:01"


#                          01 - 0 is for OFL and 1 is for Pod 1
#  Need to substitute in Pod ID Variable and not pass starting Blocks
# sending MOIDs for Identity Pools:  MAC, WWNN, WWPN
  mac_pool_moid = module.imm_pool_mod.mac_pool_moid
  wwnn_pool_moid = module.imm_pool_mod.wwnn_pool_moid
  wwpn_pool_a_moid = module.imm_pool_mod.wwpn_pool_a_moid
  wwpn_pool_b_moid = module.imm_pool_mod.wwpn_pool_b_moid


  tags = [
    { "key" : "Environment", "value" : "dev-ofl" },
    { "key" : "Orchestrator", "value" : "Terraform" }
  ]

depends_on = [
  module.imm_pool_mod
]

}
