#__________________________________________________________
#
# Local Variables Section
#__________________________________________________________

locals {

#  The following are defined as "local" variables (local.<variable>)
# Local variables are typically used for data transformation or to set initial values
# Sensitive information should be stored in variables (var.<variable>) to be passed in
#    var.<variables can be passed in from TFCB, CLI apply parameters and environment variables


  pod_policy_prefix = "dc1-pod2"                           # <-- change when copying
  
  pod_id = "12"                                                # <-- change when copying
#           1 is for DC-1    2 is DC-2     DC-3 is 3  other locations TBD (0 is Test)
#           1 is for first pod  2 is for second pod,  3 is for third pod    etc. 
#  Example DC-1 Pod 2 ID would be:  "12"
#  All Identity Pools for a Pod will contain the POD ID (MAc, WWNN, WWPN, UUID)

  description = "Built by Terraform ${local.pod_policy_prefix}"

# Intersight Organization Variable
  org_moid = data.intersight_organization_organization.my_org.id
  

#Every object created in the pod main module will have these tags
  pod_tags = [
    { "key" : "environment", "value" : "dev" },
    { "key" : "orchestrator", "value" : "Terraform" },
    { "key" : "pod", "value" : "${local.pod_policy_prefix}" }
  ]

# Pod VLANS assigned to all FI Switches in the Pod
  pod_vlans = "100,101,200-599,997-999,1200-1250"

# Pod CIMC User Policy for Server KVM Access
  iam_user_policy_moid = module.imm_pod_user_policy_1.iam_user_policy_moid


# VNIC QoS policy moids Pod-Wide
  vnic_qos_besteffort = module.imm_pod_qos_mod.vnic_qos_besteffort_moid
  vnic_qos_bronze     = module.imm_pod_qos_mod.vnic_qos_bronze_moid
  vnic_qos_silver     = module.imm_pod_qos_mod.vnic_qos_silver_moid
  vnic_qos_gold       = module.imm_pod_qos_mod.vnic_qos_gold_moid
  # vnic_qos_platinum = module.imm_pod_qos_mod.vnic_qos_platinum_moid
  vnic_qos_fc_moid    = module.imm_pod_qos_mod.vnic_qos_fc_moid
  

}