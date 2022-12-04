# Create a sequential IP pool for IMC access. Change the from and size to what you would like

resource "intersight_ippool_pool" "ippool_podpool" {
  name = "${local.pod_policy_prefix}-ip-podpool"
  description = "ofl Pod IP Pool for all KVM & Chassis"
  assignment_order = "sequential"
  ip_v4_blocks {
    from = "10.10.10.101"
    size = "99"
  }
  ip_v4_config {
    object_type = "ippool.IpV4Config"
    gateway = "10.10.10.1"
    netmask = "255.255.255.0"
    primary_dns = "8.8.8.8"
    }
  organization {
      object_type = "organization.Organization"
      moid = local.org_moid
      }
}
