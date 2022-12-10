# This defines the desired configuration of the dev-ofl-pod1-vmw-1 IMM domain
# Modules are used with supplied values to define the desired configuration of the domain infrastructure


module "intersight_policy_bundle_lnx_1" {
  #source = "github.com/pl247/tf-intersight-policy-bundle"
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/imm-domain-fabric-6536"

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------

  # external sources
  organization    = data.intersight_organization_organization.ofl.id

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # every policy created will have this prefix in its name
  policy_prefix = "ofl-dev-pod1-lnx1"
  description   = "built by Terraform cen-iac-imm-dev-pod1 code"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "ofl-dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "domain", "value" : "ofl-dev-pod1-lnx1" }
  ]

# =============================================================================
# Fabric Interconnect 6536 Ethernet ports
# -----------------------------------------------------------------------------

  server_ports_6536 = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
  port_channel_6536 = [31, 32, 33, 34]

# =============================================================================
# Fabric Interconnect 6536 FC Ports and VSANs
# -----------------------------------------------------------------------------
  # 6536 FC capable ports are 33-36 (FC ports are on the right, slider starts at 36)

  # For each FC port, it is broken-out into 4x 32G FC Ports
  # A value of 2 results in 8x 32G FC Port breakouts from ports 35 & 36
  fc_port_count_6536 = 2

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

  # VSAN Name Prefix is prepended to the VSAN number
    vsan_name_prefix = "vsan-"

# VSAN Trunking is enabled by default. One or more VSANs are required for each FI
  # Fabric A VSANs
    fc_6536_vsans_a = [
    { "vsan_a" : 100, "fcoe_a_vlan" : 10 },
    { "vsan_a" : 101, "fcoe_a_vlan" : 11 }
  ]

  # Fabric B VSANs
    fc_6536_vsans_b = [
    { "vsan_b" : 200, "fcoe_b_vlan" : 20 },
    { "vsan_b" : 201, "fcoe_b_vlan" : 21 }
  ]

# =============================================================================
# Chassis
# -----------------------------------------------------------------------------

  chassis_9508_count = 15
  chassis_imc_access_vlan    = 999
  chassis_imc_ip_pool_moid = module.imm_pool_mod.ip_pool_moid
  # Chassis requires In-Band IP's Only  (ie must be a VLAN trunked to FI's)

# =============================================================================
# NTP, DNS and SNMP Settings
# -----------------------------------------------------------------------------

  ntp_servers = ["ca.pool.ntp.org"]
  ntp_timezone  = "America/Chicago"

  dns_preferred = "8.8.8.8"
  dns_alternate = "8.8.4.4"

  snmp_ip       = "127.0.0.1"
  snmp_password = "Cisco123"
  

  # Uplink VLANs Allowed List    Example: "5,6,7,8,100-130,998-1011"
  switch_vlans_6536 = "5,10,102,313-314,1000-1111"


# The Pools for the Pod must be created before this domain fabric module executes
  depends_on = [
    module.imm_pool_mod
]

}
