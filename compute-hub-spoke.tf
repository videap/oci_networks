resource "oci_core_instance" "VM1-Public" {
    availability_domain     = data.oci_identity_availability_domain.ad.name
    compartment_id          = var.compartment_ocid
    shape                   = var.instance_shape
    display_name            = "VM1-Public-vcn1"
    preserve_boot_volume    = false

    create_vnic_details {
        assign_public_ip    = "true"
        subnet_id           = oci_core_subnet.publicsubnet1.id
    }
    # Configuration needed for Flex shapes
    # shape_config {
    #    memory_in_gbs   = "1"
    #    ocpus           = "1"
    # }
    metadata = {
        ssh_authorized_keys = var.ssh_public_key
    }
    
    source_details {
        source_id   = data.oci_core_images.vm-images.images[0]["id"]
        source_type = "image"
    }
}

resource "oci_core_instance" "VM2-Public" {
   availability_domain     = data.oci_identity_availability_domain.ad.name
   compartment_id          = var.compartment_ocid
   shape                   = var.instance_shape
   display_name            = "VM2-Public-vcn2"
   preserve_boot_volume    = false

   create_vnic_details {
       assign_public_ip    = "true"
       subnet_id           = oci_core_subnet.publicsubnet2.id
   }
    # Configuration needed for Flex shapes
    # shape_config {
    #     memory_in_gbs   = "1"
    #     ocpus           = "1"
    # }
   metadata = {
       ssh_authorized_keys = var.ssh_public_key
   }
    
   source_details {
       source_id   = data.oci_core_images.vm-images.images[0]["id"]
       source_type = "image"
   }
}

# resource "oci_core_instance" "VM4-Public" {
#     availability_domain     = data.oci_identity_availability_domain.ad.name
#     compartment_id          = var.compartment_ocid
#     shape                   = var.instance_shape
#     display_name            = "VM4-Public-vcn4"
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
#         source_id   = data.oci_core_images.vm-images.images[0]["id"]
#         source_type = "image"
#     }
# }