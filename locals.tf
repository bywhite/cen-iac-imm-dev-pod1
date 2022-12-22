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
  org_moid = data.intersight_organization_organization.ofl_dev.id
  
  pod_policy_prefix = "ofl-dev-pod1" 
  
  pod_id = "01"
#           0 is for OFL    RCO is 1     BUF is 3  other locations TBD
#           1 is for first pod  2 is for second pod,  3 is for third pod    etc. 
#  Example RCO Pod 2 ID would be:  "12"
#  All Identity Pools for a Pod will contain the POD ID (MAc, WWNN, WWPN, UUID)

  #Every object created in the pod main module will have these tags
  pod_tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "ofl-dev-pod1" }
  ]

# Fabric QoS System Class moid to be assigned to FI-A and FI-B switch profiles
  system_qos_moid =  intersight_fabric_system_qos_policy.pod_qos1.moid


}