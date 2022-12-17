# =============================================================================
# Pod FI and Server Related QoS Policies
#  - System QoS Policy to define enabled Classes of Service (CoS)
#  - vNic QoS Policies for each class of service
# -----------------------------------------------------------------------------



# This will create the default System QoS policy with some generic settings
# FlexPod: https://www.cisco.com/c/en/us/td/docs/unified_computing/ucs/UCS_CVDs/flexpod_datacenter_vmware_netappaffa.html
# Needs customization for vNics to change from best effort with MTU 1500 to MTU 9216 and higher priority
resource "intersight_fabric_system_qos_policy" "pod_qos1" {
  name        = "${local.pod_policy_prefix}-pod-qos-policy1"
  description = "Common QoS - CoS Definition for the Pod"
  organization {
    moid        = var.organization
    object_type = "organization.Organization"
  }
  classes {
    admin_state        = "Enabled"
    bandwidth_percent  = 14  # Optional
    weight             = 5
    cos                = 255
    mtu                = 1500
    multicast_optimize = false
    name               = "Best Effort"
    packet_drop        = true
    class_id           = "fabric.QosClass"
    object_type        = "fabric.QosClass"    
  }
  classes {
    admin_state        = "Enabled"
    bandwidth_percent  = 20   # Optional
    weight             = 7     
    cos                = 1
    mtu                = 1500
    multicast_optimize = false
    name               = "Bronze"
    packet_drop        = true
    class_id           = "fabric.QosClass"
    object_type        = "fabric.QosClass"  
  }
  classes {
    admin_state        = "Enabled"
    bandwidth_percent  = 23    # Optional
    weight             = 8
    cos                = 2
    mtu                = 9216
    multicast_optimize = false
    name               = "Silver"
    packet_drop        = true
    class_id           = "fabric.QosClass"
    object_type        = "fabric.QosClass"    
  }
  # Class of Service 3 is used for FibreChannel (fcoe)
  classes {
    admin_state        = "Enabled"
    bandwidth_percent  = 14     # Optional
    weight             = 5
    cos                = 3
    mtu                = 2240
    multicast_optimize = false
    name               = "FC"
    packet_drop        = false
    class_id           = "fabric.QosClass"
    object_type        = "fabric.QosClass"    
  }
  classes {
    admin_state        = "Enabled"
    bandwidth_percent  = 29     # Optional
    weight             = 9
    cos                = 4
    mtu                = 9216
    multicast_optimize = false
    name               = "Gold"
    packet_drop        = true
    class_id           = "fabric.QosClass"
    object_type        = "fabric.QosClass"    
  }
  classes {
    admin_state        = "Disabled"
    # bandwidth_percent  = 0      # Optional
    weight             = 10
    cos                = 5
    mtu                = 9216
    multicast_optimize = false
    name               = "Platinum"
    packet_drop        = true
    class_id           = "fabric.QosClass"
    object_type        = "fabric.QosClass"    
  }

}


resource "intersight_vnic_eth_qos_policy" "pod_qos_besteffort" {
  name           = "${local.pod_policy_prefix}-qos-besteffort"
  description    = "Pod QoS policy Best-Effort"
  mtu            = 1500
  rate_limit     = 0
  cos            = 0
  burst          = 1024
  priority       = "Best Effort"
  trust_host_cos = false
  organization {
    moid = var.organization
  }
}

resource "intersight_vnic_eth_qos_policy" "pod_qos_bronze" {
  name           = "${local.pod_policy_prefix}-qos-bronze"
  description    = "Pod QoS policy Bronze"
  mtu            = 1500
  rate_limit     = 0
  cos            = 1
  burst          = 1024
  priority       = "Bronze"
  trust_host_cos = false
  organization {
    moid = var.organization
  }
}

resource "intersight_vnic_eth_qos_policy" "vnic_qos_silver" {
  name           = "${local.pod_policy_prefix}-qos-silver"
  description    = "Pod QoS policy Silver"
  mtu            = 9000       # Max value 9000
  rate_limit     = 0
  cos            = 2
  burst          = 1024
  priority       = "Silver"
  trust_host_cos = false
  organization {
    moid = var.organization
  }
}


resource "intersight_vnic_eth_qos_policy" "vnic_qos_gold" {
  name           = "${local.pod_policy_prefix}-qos-gold"
  description    = "Pod QoS policy Gold"
  mtu            = 9000       # Max value 9000
  rate_limit     = 0
  cos            = 4
  burst          = 1024
  priority       = "Gold"
  trust_host_cos = false
  organization {
    moid = var.organization
  }
}





resource "intersight_vnic_fc_qos_policy" "pod_qos_fc" {
  name                = "${local.pod_policy_prefix}-qos-fc"
  description         = "Pod QoS policy for FC"
  burst               = 10240
  rate_limit          = 0
  cos                 = 3
  max_data_field_size = 2112
  organization {
    object_type = "organization.Organization"
    moid        = var.organization
  }
}
