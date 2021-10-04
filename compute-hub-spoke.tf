# resource "oci_core_instance" "VM1-Public" {
#     availability_domain     = data.oci_identity_availability_domain.ad.name
#     compartment_id          = var.compartment_ocid
#     shape                   = var.instance_shape
#     display_name            = "VM-Public-vcn1"
#     preserve_boot_volume    = false

#     create_vnic_details {
#         assign_public_ip    = "true"
#         subnet_id           = oci_core_subnet.publicsubnet1.id
#     }

#     #shape_config {
#     #    memory_in_gbs   = "1"
#     #    ocpus           = "1"
#     #}
#     metadata = {
#         ssh_authorized_keys = var.ssh_public_key
#     }
    
#     source_details {
#         source_id   = var.ol_image_ocid[var.region]
#         source_type = "image"
#     }
# }

resource "oci_core_instance" "VM2-A-Public" {
   availability_domain     = data.oci_identity_availability_domain.ad.name
   compartment_id          = var.compartment_ocid
   shape                   = var.instance_shape
   display_name            = "VM2-Public-vcn2"
   preserve_boot_volume    = false

   create_vnic_details {
       assign_public_ip    = "true"
       subnet_id           = oci_core_subnet.publicsubnet2.id
   }

#    shape_config {
#        memory_in_gbs   = "1"
#        ocpus           = "1"
#    }
   metadata = {
       ssh_authorized_keys = var.ssh_public_key
   }
    
   source_details {
       source_id   = var.ol_image_ocid[var.region]
       source_type = "image"
   }
}

# resource "oci_core_instance" "VM2-B-Private" {
#    availability_domain     = data.oci_identity_availability_domain.ad.name
#    compartment_id          = var.compartment_ocid
#    shape                   = var.instance_shape
#    display_name            = "VM-B-Private-vcn2"
#    preserve_boot_volume    = false

#    create_vnic_details {
#        assign_public_ip    = "false"
#        subnet_id           = oci_core_subnet.privatesubnet2.id
#    }

# #    shape_config {
# #        memory_in_gbs   = "1"
# #        ocpus           = "1"
# #    }
#    metadata = {
#        ssh_authorized_keys = var.ssh_public_key
#    }
    
#    source_details {
#        source_id   = var.ol_image_ocid[var.region]
#        source_type = "image"
#    }
# }

# resource "oci_core_instance" "VM2-Private" {
#     availability_domain     = data.oci_identity_availability_domain.ad.name
#     compartment_id          = var.compartment_ocid
#     shape                   = var.instance_shape
#     display_name            = "VM-Private-VCN2"
#     preserve_boot_volume    = false

#     create_vnic_details {
#         assign_public_ip    = "false"
#         subnet_id           = oci_core_subnet.privatesubnet2.id
#     }

#     #shape_config {
#     #    memory_in_gbs   = "1"
#     #    ocpus           = "1"
#     #}
#     metadata = {
#         ssh_authorized_keys = var.ssh_public_key
#     }
    
#     source_details {
#         source_id   = var.ol_image_ocid[var.region]
#         source_type = "image"
#     }
# }

resource "oci_core_instance" "VM3-Public" {
    availability_domain     = data.oci_identity_availability_domain.ad.name
    compartment_id          = var.compartment_ocid
    shape                   = var.instance_shape
    display_name            = "Jumper_VCN3"
    preserve_boot_volume    = false

    create_vnic_details {
        assign_public_ip    = "true"
        subnet_id           = oci_core_subnet.publicsubnet3.id
    }

    #shape_config {
    #    memory_in_gbs   = "1"
    #    ocpus           = "1"
    #}
    metadata = {
        ssh_authorized_keys = var.ssh_public_key
    }
    
    source_details {
        source_id   = var.ol_image_ocid[var.region]
        source_type = "image"
    }
}

# resource "oci_core_instance" "VM4-Public" {
#     availability_domain     = data.oci_identity_availability_domain.ad.name
#     compartment_id          = var.compartment_ocid
#     shape                   = var.instance_shape
#     display_name            = "VM4-Public-VCN4"
#     preserve_boot_volume    = false

#     create_vnic_details {
#         assign_public_ip    = "true"
#         subnet_id           = oci_core_subnet.publicsubnet4.id
#     }

#     #shape_config {
#     #    memory_in_gbs   = "1"
#     #    ocpus           = "1"
#     #}
#     metadata = {
#         ssh_authorized_keys = var.ssh_public_key
#     }
    
#     source_details {
#         source_id   = var.ol_image_ocid[var.region]
#         source_type = "image"
#     }
# }