
variable "compartment_ocid" {}
variable "region" {}
variable "instance_shape" {}
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "ssh_public_key" {}
variable "vm_os"{}
variable "vm_os_version"{}
variable "vm_shape"{}
variable "vcn1_cidr"{}
variable "vcn1_dnslabel"{}
variable "vcn2_cidr"{}
variable "vcn2_dnslabel"{}
variable "vcn3_cidr"{}
variable "vcn3_dnslabel"{}
variable "vcn4_cidr"{}
variable "vcn4_dnslabel"{}
variable "ad_number" {}

variable "pfsense_image_id" {
  description = "If pfsense image already exists, insert the Image OCID. If not, leave it blank."
}


data "oci_identity_availability_domain" "ad" {
  compartment_id  = var.tenancy_ocid
  ad_number       = var.ad_number
}

data "oci_core_images" "vm-images" {
  compartment_id           = var.compartment_ocid
  operating_system         = var.vm_os
  operating_system_version = var.vm_os_version
  shape                    = var.vm_shape
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}