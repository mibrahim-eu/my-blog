terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
      version = "3.2.5"
    }
  }
}

provider "nsxt" {
  host                 = "https://nsx-1-38-60-79.rp.vmwarevmc.com/vmc/reverse-proxy/api/orgs/53045f5a-59f7-4921-8bcb-0b09e8c3ac16/sddcs/24163dc6-2b22-475b-b197-167932ef5124/sks-nsxt-manager"
  vmc_token            = "12345IZf8Elb9VFTorfvnoyk6CsDXi15678utfdsFHfdsdafsadfasfIUTdghuy7815"
  allow_unverified_ssl = true
  enforcement_point    = "vmc-enforcementpoint"
}



resource "nsxt_policy_fixed_segment" "Terraform-segment1" {
  display_name      = "Terraform-segment1"
  description       = "Terraform provisioned Segment"
  connectivity_path = "/infra/tier-1s/cgw"

  subnet {
    cidr        = "12.12.2.1/24"
    dhcp_ranges = ["12.12.2.100-12.12.2.160"]

    dhcp_v4_config {
      server_address = "12.12.2.2/24"
      lease_time     = 36000
    
    }
  }
}
