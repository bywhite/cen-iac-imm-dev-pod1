#__________________________________________________________
#
# Local Variables Section
#__________________________________________________________

locals {

#  The following are defined as variables (var.) in the TFCB workspace
#  endpoint (http://intersight.com)
#  api_key  (ID for Intersight)
#  secretkey (Key for Intersight)
#  imc_admin_password



  # Intersight Organization Variable
  org_moid = data.intersight_organization_organization.ofl.id
  
  pod_policy_prefix = "dev-ofl-pod1" 
#  policy_prefix = "dev-ofl-pod1"      >>used in pod1-vmw-1.tf to create IMM Domain
  
  pod_id = "01"
#           0 is for OFL    RCO is 1     BUF is 3  other locations TBD
#           1 is for Pod 1  Pod 2 is 2   Pod 3 is 3    etc. 
#  Example RCO Pod 2 ID would be:  "12"
#  All Identity Pools for a Pod will contain the POD ID (MAc, WWNN, WWPN, UUID)

  #Every object created in the pod main module will have these tags
  pod_tags = [
    { "key" : "environment", "value" : "ofl-dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "ofl-dev-pod1" }
  ]

}