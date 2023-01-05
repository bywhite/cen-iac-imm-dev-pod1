# # =============================================================================
# # This defines the desired configuration of the ofl-dev-pod1-vmw-1 IMM domain
# # 
# # Builds: Domain Cluster, Switch, and Chassis Profiles & their Policies
# #         configured for 6536 FI and 9508 chassis (May work with 5108 chassis)
# # -----------------------------------------------------------------------------


module "intersight_policy_bundle_lnx_1" {             # <-- change when copying
  #source = "github.com/pl247/tf-intersight-policy-bundle"
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/imm-domain-fabric-6536"

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------

  # external sources
  organization    = local.org_moid

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # every policy created will have this prefix in its name
  policy_prefix = "ofl-dev-pod1-lnx-1"                # <-- change when copying
  description   = "built by Terraform cen-iac-imm-dev-pod1"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "ofl-dev-pod1" },
    { "key" : "domain", "value" : "ofl-dev-pod1-lnx1" } # <-- change when copying
  ]

# =============================================================================
# Fabric Interconnect 6536 Ethernet ports
# -----------------------------------------------------------------------------

  #FI ports to be used for ethernet port channel uplink
  port_channel_6536 = [31, 32, 33, 34]

  # Number of physical ethernet ports to be used for 25G 4x breakout ports to chassis
  eth_breakout_count = 2
  eth_breakout_start = 29

  # FI physical port numbers to be attached to X-series chassis, including breakouts to B-series chassis 
  server_ports_6536 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28]

  eth_aggr_server_ports = {
    "agg29-1"  = {  
      aggregate_port_id  = "29"
      port_id            = "1"
    }
    "agg29-2"  = {
      aggregate_port_id  = "29"
      port_id            = "2" 
    }
   "agg29-3"  = {   
      aggregate_port_id  = "29"
      port_id            = "3"
    }
    "agg29-4"  = {
      aggregate_port_id  = "29"
      port_id            = "4"
    }
    "agg30-1"  = {  
      aggregate_port_id  = "30"
      port_id            = "1"
    }
    "agg30-2"  = {
      aggregate_port_id  = "30"
      port_id            = "2"
    }
   "agg30-3"  = {
      aggregate_port_id  = "30"
      port_id            = "3"
    }
    "agg30-4"  = {
      aggregate_port_id  = "30"
      port_id            = "4"
    }
  }
  

  # Uplink VLANs Allowed List    Example: "5,6,7,8,100-130,998-1011"
  switch_vlans_6536 = "100,101,102,313,314,997-999"


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
    { "vsan_a" : 100, "fcoe_a_vlan" : 1000 },
    { "vsan_a" : 101, "fcoe_a_vlan" : 1001 }
  ]

  # Fabric B VSANs
    fc_6536_vsans_b = [
    { "vsan_b" : 200, "fcoe_b_vlan" : 2000 },
    { "vsan_b" : 201, "fcoe_b_vlan" : 2001 }
  ]

  # Fabric A VSAN Set
  fabric_a_vsan_sets = {
    "vsan100" = {
      vsan_number   = 100
      fcoe_number   = 1000
      switch_id      = "A"
    }
    "vsan101"  = {
      vsan_number   = 101
      fcoe_number   = 1001
      switch_id      = "A"
    }
  }

  # Fabric B VSAN Set
    fabric_b_vsan_sets = {
    "vsan200" = {
      vsan_number   = 200
      fcoe_number   = 2000
      switch_id      = "B"
    }
    "vsan201"  = {
      vsan_number   = 201
      fcoe_number   = 2001
      switch_id      = "B"
    }
  }

# =============================================================================
# Chassis
# -----------------------------------------------------------------------------

  chassis_9508_count = 15
  chassis_imc_access_vlan    = 999
  chassis_imc_ip_pool_moid = module.imm_pool_mod.ip_pool_moid
  # Chassis requires In-Band IP's Only  (ie must be a VLAN trunked to FI's)
  # Need chassis_imc_access_password from TFCB Workspace Variable

# =============================================================================
# NTP, DNS and SNMP Settings
# -----------------------------------------------------------------------------

  ntp_servers = ["ca.pool.ntp.org"]
  ntp_timezone  = "America/Chicago"

  dns_preferred = "8.8.8.8"
  dns_alternate = "8.8.4.4"

  snmp_ip       = "127.0.0.1"
  snmp_password = var.snmp_password
  
# The Pools for the Pod must be created before this domain fabric module executes
  depends_on = [
    module.imm_pool_mod, module.imm_pod_qos_mod
]

}
