provider "nsxt" {
  host                 = var.host
  vmc_token            = var.token
  allow_unverified_ssl = true
  enforcement_point    = "vmc-enforcementpoint"
}



resource "nsxt_policy_fixed_segment" "projectLSW" {
  display_name      = "LSW-VMC-${var.lswNumber}-01"
  connectivity_path =  var.connectivity_path   

   subnet {
    cidr = var.subnet

  }

   tag {
    scope = "LSW"
    tag   = "LSW-VMC-${var.lswNumber}-01"
  }

  advanced_config {
    connectivity = "OFF"
  }
}



resource "nsxt_policy_group" "projectSG" {
  display_name = "SG-VMC-VPC-${var.lswNumber}"
  domain       = "cgw"
  criteria {
    condition {
      key         = "Tag"
      member_type = "Segment"
      operator    = "EQUALS"
      value       = "LSW-VMC-${var.lswNumber}-01"
    }

  }

}




#This VM is used for NSX-T TAGs , any new TAG should be created and applied to this , then you can use it for the other VMs
resource "nsxt_policy_vm_tags" "projectTAGs" {
  instance_id = var.vmBIOS

  tag {
    scope = "FWP"
    tag   = "FWP-${var.lswNumber}-Dummy"
  }

}




  resource "nsxt_policy_security_policy" "projectFWP" {
  display_name = "FWP-VPC-${var.lswNumber}"
  category   = "Application"
  scope      = [nsxt_policy_group.projectSG.path]
  domain       = "cgw"
  locked     = false
  stateful   = true
  tcp_strict = false

  rule {
    display_name       = "FWR-VPC-${var.lswNumber}-IntraTraffic"
    source_groups      = [nsxt_policy_group.projectSG.path]
    destination_groups = [nsxt_policy_group.projectSG.path]
    scope              = [nsxt_policy_group.projectSG.path]
    action             = "ALLOW"
    logged             = true
  }


  }
