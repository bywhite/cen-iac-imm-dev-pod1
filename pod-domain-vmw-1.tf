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
  server_ports_6536 = [3, 4, 5, 6, 7, 8]
  port_channel_6536 = [33, 34]
  uplink_vlans_6536 = {
    "vlan-998" : 998,
    "vlan-999" : 999
  }
  fc_port_count_6536 = 2
     #For each port_count physical port above, it is broken-out into 4x 32G FC Ports
     #A value of 2 results in 8x 32G FC Port breakouts from ports 35 & 36
     # Unified Ports 33-36 (FC ports on right of the slider starting with 36)
  fc_port_channel_6536 = [
    { "aggport" : 35, "port" : 1 },
    { "aggport" : 35, "port" : 2 },
    { "aggport" : 35, "port" : 3 },
    { "aggport" : 35, "port" : 4 },
    { "aggport" : 36, "port" : 1 },
    { "aggport" : 36, "port" : 2 },
    { "aggport" : 36, "port" : 3 },
    { "aggport" : 36, "port" : 4 }
  ]

  chassis_imc_access_vlan    = 999
  chassis_imc_ip_pool_moid = module.imm_pool_mod.ip_pool_moid
  #Need to create separate IP Pool for Chassis

  ntp_servers = ["ca.pool.ntp.org"]

  dns_preferred = "172.22.16.254"
  dns_alternate = "172.22.16.253"
  ntp_timezone  = "America/Chicago"
  snmp_ip       = "10.20.22.22"
  snmp_password = "Cisco123"
  

  tags = [
    { "key" : "Environment", "value" : "dev-ofl" },
    { "key" : "Orchestrator", "value" : "Terraform" }
  ]
  
# The Pools must be created first before this module executes
depends_on = [
  module.imm_pool_mod
]

}
