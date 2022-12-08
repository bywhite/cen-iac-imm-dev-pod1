# This defines the desired configuration of the dev-ofl-pod1-vmw-1 IMM domain
# Modules are used with supplied values to define the desired configuration of the domain infrastructure


module "intersight_policy_bundle" {
  #source = "github.com/pl247/tf-intersight-policy-bundle"
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/imm-domain-fabric-module"
  # external sources
  organization    = data.intersight_organization_organization.ofl.id

  # every policy created will have this prefix in its name
  policy_prefix = "dev-ofl-pod1-bml1"
  description   = "Built by Terraform cen-iac-imm-dev-pod1 code"

  # Fabric Interconnect 6454 config specifics
  server_ports_6454 = [17, 18, 19, 20, 21, 22]
  port_channel_6454 = [49, 50]
  uplink_vlans_6454 = {
    "vlan-998" : 998,
    "vlan-999" : 999
  }
  fc_port_count_6454 = 4
  #6454 FC ports start at Port 1 up to 16 (FC on left of slider)


  chassis_imc_access_vlan    = 999
  chassis_imc_ip_pool_moid = module.imm_pool_mod.ip_pool_moid
  #Need to create separate IP Pool for Chassis

  ntp_servers = ["ca.pool.ntp.org"]
  ntp_timezone = "America/Chicago"
  dns_preferred = "172.22.16.254"
  dns_alternate = "172.22.16.253"

  tags = [
    { "key" : "Environment", "value" : "dev-ofl" },
    { "key" : "Orchestrator", "value" : "Terraform" }
  ]

depends_on = [
  module.imm_pool_mod
]

}
