// Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

#CRIACAO DE VCN 3 e VCN 4. PFSENSE NA VCN 3 E FECHAR VPN

resource "oci_core_vcn" "vcn3" {
  cidr_blocks    =  ["10.2.0.0/16"]
  dns_label      = "vcn3tf"
  compartment_id = var.compartment_ocid
  display_name   = "vcn3-tf"
}

resource "oci_core_internet_gateway" "igw3" {
    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn3.id
    display_name    = "IGW3"
}

resource "oci_core_route_table" "publicRT3" {
    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn3.id
    display_name    = "PublicRT3"

    route_rules {
        network_entity_id   = oci_core_internet_gateway.igw3.id
        destination          = "0.0.0.0/0"
    }

    route_rules {
        network_entity_id   = oci_core_local_peering_gateway.lpg3.id
        destination          = oci_core_vcn.vcn4.cidr_blocks[0]
    }
}

resource "oci_core_route_table" "privateRT3" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn3.id
    display_name    = "PrivateRT3"

    route_rules {
        network_entity_id   = oci_core_local_peering_gateway.lpg3.id
        destination          = oci_core_vcn.vcn4.cidr_blocks[0]
    }

    route_rules {
        network_entity_id   = data.oci_core_private_ips.pfsense-ip2.private_ips[0].id
        destination         = "0.0.0.0/0"
    }
}

resource "oci_core_route_table" "lpg3_RT" {
    depends_on      = [oci_core_vnic_attachment.pfsense_vnic2]

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn3.id
    display_name    = "LPG3_RT"

    route_rules {
        network_entity_id   = data.oci_core_private_ips.pfsense-ip2.private_ips[0].id
        destination         = "0.0.0.0/0"
    }
}

resource "oci_core_security_list" "publicSL3" {
    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn3.id
    display_name    = "PublicSL3"

    ingress_security_rules {
        protocol    = "all"
        source      = "0.0.0.0/0"
    }

    egress_security_rules {
        destination     = "0.0.0.0/0"
        protocol        = "all"
    }
}

resource "oci_core_security_list" "privateSL3" {
    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn3.id
    display_name    = "PrivateSL3"

    ingress_security_rules {
        protocol    = "all"
        source      = "0.0.0.0/0"
    }

    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol    = "all"
    }
}

resource "oci_core_subnet" "publicsubnet3" {
    cidr_block          = "10.2.0.0/24"
    compartment_id      = var.compartment_ocid
    vcn_id              = oci_core_vcn.vcn3.id
    display_name        = "PublicSubnet3"
    #route_table_id      = oci_core_route_table.publicRT3.id
    security_list_ids   = [oci_core_security_list.publicSL3.id]
}

resource "oci_core_subnet" "privatesubnet3" {
    cidr_block          = "10.2.1.0/24"
    compartment_id      = var.compartment_ocid
    vcn_id              = oci_core_vcn.vcn3.id
    display_name        = "PrivateSubnet3"
    #route_table_id     = oci_core_route_table.privateRT3.id
    security_list_ids   = [oci_core_security_list.privateSL3.id]
    prohibit_public_ip_on_vnic = "true"
}


resource "oci_core_route_table_attachment" "route_table3_priv_attachment" {
  //dependancy on the vnic attachment
  depends_on = [oci_core_vnic_attachment.pfsense_vnic2]
  
  subnet_id = oci_core_subnet.privatesubnet3.id
  route_table_id = oci_core_route_table.privateRT3.id
}

resource "oci_core_route_table_attachment" "route_table3_public_attachment" {
  //dependancy on the vnic attachment
  depends_on = [oci_core_vnic_attachment.pfsense_vnic2]
  
  subnet_id = oci_core_subnet.publicsubnet3.id
  route_table_id = oci_core_route_table.publicRT3.id
}

########################################################

resource "oci_core_vcn" "vcn4" {
  cidr_blocks    =  ["10.3.0.0/16"]
  dns_label      = "vcn4tf"
  compartment_id = var.compartment_ocid
  display_name   = "vcn4-tf"
}

resource "oci_core_route_table" "publicRT4" {
    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn4.id
    display_name    = "PublicRT4"

    route_rules {
        network_entity_id   = oci_core_local_peering_gateway.lpg4.id
        destination          = "0.0.0.0/0"
    }
}

resource "oci_core_route_table" "privateRT4" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn4.id
    display_name    = "PrivateRT4"

    route_rules {
        network_entity_id   = oci_core_local_peering_gateway.lpg4.id
        destination         = "0.0.0.0/0"
    }

    route_rules {
        destination_type = "SERVICE_CIDR_BLOCK"
        network_entity_id   = oci_core_service_gateway.sg4.id
        destination         = data.oci_core_services.OCI_Services.services[1].cidr_block
    }
}

resource "oci_core_security_list" "publicSL4" {
    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn4.id
    display_name    = "PublicSL4"

    ingress_security_rules {
        protocol    = "all"
        source      = "0.0.0.0/0"
    }

    egress_security_rules {
        destination     = "0.0.0.0/0"
        protocol        = "all"
    }
}

resource "oci_core_security_list" "privateSL4" {
    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn4.id
    display_name    = "PrivateSL4"

    ingress_security_rules {
        protocol    = "all"
        source      = "0.0.0.0/0"
    }

    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol    = "all"
    }
}

resource "oci_core_subnet" "publicsubnet4" {
    cidr_block          = "10.3.0.0/24"
    compartment_id      = var.compartment_ocid
    vcn_id              = oci_core_vcn.vcn4.id
    display_name        = "PublicSubnet4"
    route_table_id      = oci_core_route_table.publicRT4.id
    security_list_ids   = [oci_core_security_list.publicSL4.id]
}

resource "oci_core_subnet" "privatesubnet4" {
    cidr_block          = "10.3.1.0/24"
    compartment_id      = var.compartment_ocid
    vcn_id              = oci_core_vcn.vcn4.id
    display_name        = "PrivateSubnet4"
    #route_table_id     = oci_core_route_table.privateRT4.id
    security_list_ids   = [oci_core_security_list.privateSL4.id]
    prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_route_table_attachment" "route_table_attachment4" {
  #Required
  subnet_id = oci_core_subnet.privatesubnet4.id
  route_table_id = oci_core_route_table.privateRT4.id
}

resource "oci_core_service_gateway" "sg4" {  
    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn4.id

    display_name    = "SG4"
    
    services {
        #Required
        service_id = data.oci_core_services.OCI_Services.services[1].id
    }
}

data "oci_core_services" "OCI_Services" {
}



resource "oci_core_local_peering_gateway" "lpg3" {
    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn3.id

    display_name    = "LPG3-LPG4"
    route_table_id  = oci_core_route_table.lpg3_RT.id
}

resource "oci_core_local_peering_gateway" "lpg4" {  
    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn4.id

    display_name    = "LPG4-LPG3"
    peer_id         = oci_core_local_peering_gateway.lpg3.id
}
