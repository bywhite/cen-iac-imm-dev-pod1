resource "intersight_macpool_pool" "cisco_af_1" {
  name = "cisco_af_1"
  organization    = local.org_moid

  mac_blocks {
    from = "00:25:B5:AF:10:00"
    size = 1000
  }

  organization {
    object_type = "organization.Organization"
    moid = var.organization 
  }

}
