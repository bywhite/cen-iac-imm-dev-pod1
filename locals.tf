#__________________________________________________________
#
# Local Variables Section
#__________________________________________________________

locals {
  # Intersight Organization Variable
  org_moid = data.intersight_organization_organization.ofl.id
  
  pod_policy_prefix = "dev-ofl-pod1" 
#  policy_prefix = "dev-ofl-pod1"      >>used in pod1-vmw-1.tf to create IMM Domain
  




}