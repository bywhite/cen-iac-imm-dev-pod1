# Create a sequential MAC Pool.
module "imm_pool_mod_x1" {
  source = "github.com/bywhite/cen-iac-imm-dev-pod1-mods/x1-pool-mod"

    # external sources
  organization    = data.intersight_organization_organization.my_org.id

  pod_id = "11"
  # used to create moids for Pools: MAC, WWNN, WWPN

}

