variable "host" {
  description = "The NSX endpoint for the VMC"
  type        = string

}

variable "token" {
  description = "The Token of the NSX endpoint for the VMC"
  type        = string

}



variable "connectivity_path" {
  description = "The T1 router of the internal customers of the NSX endpoint for the VMC"
  type        = string
}





variable "lswNumber" {
  description = "The username of the NSX endpoint for the VMC"

}


variable "subnet" {
  description = "This is the subnet for this project"

}

variable "vmBIOS" {
  description = "The BIOS ID of the VM that will contains all the TAGs for this Project"

}