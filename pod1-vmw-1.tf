# This defines the desired configuration of the dev-ofl-pod1-vmw-1 IMM domain
# Modules are used with supplied values to define the desired configuration of the domain infrastructure


module "intersight_policy_bundle" {
  #source = "github.com/pl247/tf-intersight-policy-bundle"
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/imm-domain-fabric-module"
  # external sources
  organization    = data.intersight_organization_organization.ofl.id

  # every policy created will have this prefix in its name
  policy_prefix = "dev-ofl-pod1"
  description   = "Built by Terraform cen-iac-imm-dev-pod1 code"

  # Fabric Interconnect 6454 config specifics
  server_ports_6454 = [17, 18, 19, 20, 21, 22]
  port_channel_6454 = [49, 50]
  uplink_vlans_6454 = {
    "vlan-998" : 998,
    "vlan-999" : 999
  }

  fc_port_count_6454 = 4

  imc_access_vlan    = 999
  imc_admin_password = "Cisco123"
  imc_ip_pool_moid = module.imm_pool_mod.ip_pool_moid

  ntp_servers = ["ca.pool.ntp.org"]

  dns_preferred = "172.22.16.254"
  dns_alternate = "172.22.16.253"

  ntp_timezone = "America/Chicago"

# starting values for wwnn, wwpn-a/b and mac pools (size 255)
  wwnn-block   = "20:00:00:CA:FE:00:00:01"
  wwpn-a-block = "20:00:00:CA:FE:0A:00:01"
  wwpn-b-block = "20:00:00:CA:FE:0B:00:01"

  mac-block    = "00:CA:FE:00:00:01"

    tags = [
    { "key" : "Environment", "value" : "dev-ofl" },
    { "key" : "Orchestrator", "value" : "Terraform" }
  ]
}
