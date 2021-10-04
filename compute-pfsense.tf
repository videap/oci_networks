
resource "oci_core_image" "pfsense_image" {
    depends_on       = [data.oci_core_images.custom_images]
    count            = var.pfsense_image_id == "" ? 1 : 0

    #Required
    compartment_id = var.compartment_ocid

    #Optional
    display_name   = "pfsense-image"
    launch_mode    = "EMULATED"

    image_source_details {
        source_type    = "objectStorageUri"
        #Pre auth expires on 31/12/21
        source_uri     = "https://objectstorage.us-ashburn-1.oraclecloud.com/p/TPXzj-BLXTeH73uR2oU9_R_c9UutIM_7GeKdddYnLn4ZqINGUMulgrtx6kw5YWV2/n/id3kyspkytmr/b/main_bucket/o/pfsense-OCI-image"
    }
}

resource "oci_core_instance" "pfsense" {
    availability_domain     = data.oci_identity_availability_domain.ad.name
    compartment_id          = var.compartment_ocid
    shape                   = var.instance_shape
    display_name            = "pfsense-Public-vcn3"
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
        source_id   = local.custom_image_pfsense ? local.custom_image_pfsense_id : oci_core_image.pfsense_image[0].id
        source_type = "image"
    }
}


resource "oci_core_vnic_attachment" "pfsense_vnic2" {
    instance_id = oci_core_instance.pfsense.id

    create_vnic_details {
        assign_public_ip = "false"
        private_ip = "10.2.1.3"
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

data "oci_core_images" "custom_images" {
    compartment_id = var.compartment_ocid
    display_name = "pfsense-image"
}

locals {
    custom_image_pfsense = contains([for x in data.oci_core_images.custom_images.images: "true" if x.display_name == "pfsense-image"], "true")
}

locals {
    custom_image_pfsense_id = var.pfsense_image_id != "" ? lookup(data.oci_core_images.custom_images.images[0], "id", "false") : var.pfsense_image_id
}

