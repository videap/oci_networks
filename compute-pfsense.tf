
#resource "oci_core_image" "pfsense_image" {
#    #Required
#    compartment_id = var.compartment_ocid
#
#    #Optional
#    display_name   = "pfsense-image"
#    launch_mode    = "EMULATED"
#
#    image_source_details {
#        source_type    = "objectStorageUri"
#        source_uri     = "https://objectstorage.us-ashburn-1.oraclecloud.com/n/id3kyspkytmr/b/main_bucket/o/pfsense-OCI-image"
#    }
#}

resource "oci_core_instance" "pfsense" {
    availability_domain     = data.oci_identity_availability_domain.ad.name
    compartment_id          = var.compartment_ocid
    shape                   = var.instance_shape
    display_name            = "pfsense-Public-VCN3"
    preserve_boot_volume    = false

    create_vnic_details {
        assign_public_ip    = "true"
        skip_source_dest_check = "true"
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
        source_id   = "ocid1.image.oc1.iad.aaaaaaaakr4b3frbylgn7fiehfllc2rpohczgna6juchji5j57sh27zn6qra"
        source_type = "image"
    }
}


resource "oci_core_vnic_attachment" "pfsense_vnic2" {
    instance_id = oci_core_instance.pfsense.id

    create_vnic_details {
        assign_public_ip = "false"
        display_name = "secondary_vnic_private"
        skip_source_dest_check = "true"
        subnet_id = oci_core_subnet.privatesubnet3.id
    }


}

data "oci_core_vnic_attachments" "vnic2-pfsense-attachment" {
    compartment_id = var.compartment_ocid
    instance_id = oci_core_instance.pfsense.id
}


data "oci_core_private_ips" "pfsense-ip2" {
    depends_on = [oci_core_vnic_attachment.pfsense_vnic2]
    vnic_id = data.oci_core_vnic_attachments.vnic2-pfsense-attachment.vnic_attachments[0].vnic_id
}

output "value" {
  value = data.oci_core_vnic_attachments.vnic2-pfsense-attachment
}
    


