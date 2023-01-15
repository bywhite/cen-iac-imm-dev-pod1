# # =============================================================================
# # This defines the desired configuration of the ofl-dev-pod1-bml-1 IMM domain
# # 
# # Builds: Domain Cluster, Switch, and Chassis Profiles & their Policies
# #         configured for 6454 FI and 9508 chassis (May work with 5108 chassis)
# # -----------------------------------------------------------------------------


module "intersight_policy_bundle_bml_1" {
  #source = "github.com/pl247/tf-intersight-policy-bundle"
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/tbd-imm-domain-fabric-6454-mod"

# =============================================================================
# Org external references
# -----------------------------------------------------------------------------

  # external sources
  organization    = local.org_moid

# =============================================================================
# Naming and tagging
# -----------------------------------------------------------------------------

  # every policy created will have this prefix in its name
  policy_prefix = "ofl-dev-pod1-bml-1"                # <-- change when copying
  description   = "built by Terraform cen-iac-imm-dev-pod1"

  #Every object created in the domain will have these tags
  tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "ofl-dev-pod1" },
    { "key" : "domain", "value" : "ofl-dev-pod1-bml1" } # <-- change when copying
  ]


# =============================================================================
# Fabric Interconnect 6536 Ethernet ports
# -----------------------------------------------------------------------------

  #FI ports to be used for ethernet port channel uplink
  port_channel_6536 = [49,50,51,52]





  # FI physical port numbers to be attached to chassis 
  server_ports_6536 = [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44]



  # Uplink VLANs Allowed List    Example: "5,6,7,8,100-130,998-1011"
  switch_vlans_6536 = "100,101,102,313,314,997-999"


# =============================================================================
# Fabric Interconnect 6536 FC Ports and VSANs
# -----------------------------------------------------------------------------
    #6454 FC ports start at Port 1 up to 16 (FC on left of slider)

  # A value of 8 results in 8x 32G FC Port from ports 1 to 8
  fc_port_count_6454 = 8

  # VSAN Name Prefix is prepended to the VSAN number
    vsan_name_prefix = "vsan-"
  
    fc_port_channel_6536 = [
    { "aggport" : 1, "port" : 1 },
    { "aggport" : 1, "port" : 2 },
    { "aggport" : 1, "port" : 3 },
    { "aggport" : 1, "port" : 4 },
    { "aggport" : 1, "port" : 5 },
    { "aggport" : 1, "port" : 6 },
    { "aggport" : 1, "port" : 7 },
    { "aggport" : 1, "port" : 8 }
  ]


# VSAN Trunking is enabled by default. One or more VSANs are required for each FI

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
  chassis_imc_ip_pool_moid = module.imm_pool_mod.ip_pool_chassis_moid 
  # Chassis requires In-Band IP's Only  (ie must be a VLAN trunked to FI's)
  # Need chassis_imc_access_password from TFCB Workspace Variable

# =============================================================================
# NTP, DNS and SNMP Settings
# -----------------------------------------------------------------------------

  ntp_servers   = ["ca.pool.ntp.org"]
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
