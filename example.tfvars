#Fill the following information for the OCI provider:
#Additional information can be found in https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformproviderconfiguration.htm
user_ocid        = ""
tenancy_ocid     = ""
fingerprint      = ""
private_key_path = ""

compartment_ocid = ""

region           = "us-phoenix-1"
ad_number        = "1"

##  Network ip Ranges
vcn1_cidr       = ["10.0.0.0/16"]
vcn1_dnslabel   = "vcn1"

vcn2_cidr       = ["10.1.0.0/16"]
vcn2_dnslabel   = "vcn2"

vcn3_cidr       = ["10.2.0.0/16"]
vcn3_dnslabel   = "vcn3"

vcn4_cidr       = ["10.3.0.0/16"]
vcn4_dnslabel   = "vcn4"


## Virtual Machine Variables
instance_shape   = "VM.Standard2.1"
vm_os            = "Oracle Linux"
vm_os_version    = "8"
vm_shape         = "VM.Standard2.1"
ssh_public_key   = ""



