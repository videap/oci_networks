// Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

#CRIAÇAO DE VCN 1 e 2. VPN SERA FECHADA COM PFSENSE NA REDE 3

resource "oci_core_vcn" "vcn1" {
  cidr_blocks    =  ["10.0.0.0/16"]
  dns_label      = "vcn1tf"
  compartment_id = var.compartment_ocid
  display_name   = "vcn1-tf"
}

resource "oci_core_vcn" "vcn2" {
  cidr_blocks    = ["10.1.0.0/16"]
  dns_label      = "vcn2tf"
  compartment_id = var.compartment_ocid
  display_name   = "vcn2-tf"
}

resource "oci_core_drg" "drg1" {
    compartment_id  = var.compartment_ocid
    display_name    = "DRG1"
}

resource "oci_core_drg_attachment" "drg_and_vcn1" {

    drg_id = oci_core_drg.drg1.id
    vcn_id = oci_core_vcn.vcn1.id
}

resource "oci_core_internet_gateway" "igw1" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn1.id
    display_name    = "IGW1"
}

resource "oci_core_internet_gateway" "igw2" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn2.id
    display_name    = "IGW2"
}

resource "oci_core_nat_gateway" "nat1" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn1.id
    display_name    = "NAT1"
}

resource "oci_core_nat_gateway" "nat2" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn2.id
    display_name    = "NAT2"
}

resource "oci_core_route_table" "publicRT1" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn1.id
    display_name    = "PublicRT1"

    route_rules {
        network_entity_id   = oci_core_internet_gateway.igw1.id
        destination          = "0.0.0.0/0"
    }

    route_rules {
        network_entity_id   = oci_core_local_peering_gateway.lpg1.id
        destination          = oci_core_vcn.vcn2.cidr_blocks[0]
    }

    route_rules {
        network_entity_id   = oci_core_drg.drg1.id
        destination          = oci_core_vcn.vcn3.cidr_blocks[0]
    }
}

resource "oci_core_route_table" "publicRT2" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn2.id
    display_name    = "PublicRT2"

    route_rules {
        network_entity_id   = oci_core_internet_gateway.igw2.id
        destination          = "0.0.0.0/0"
    }

    route_rules {
        network_entity_id   = oci_core_local_peering_gateway.lpg2.id
        destination          = oci_core_vcn.vcn1.cidr_blocks[0]
    }

    route_rules {
        network_entity_id   = oci_core_local_peering_gateway.lpg2.id
        destination          = oci_core_vcn.vcn3.cidr_blocks[0]
    }

}

resource "oci_core_route_table" "privateRT1" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn1.id
    display_name    = "PrivateRT1"

    route_rules {
        network_entity_id   = oci_core_nat_gateway.nat1.id
        destination          = "0.0.0.0/0"
    }

    route_rules {
        network_entity_id   = oci_core_local_peering_gateway.lpg1.id
        destination          = oci_core_vcn.vcn2.cidr_blocks[0]
    }

    route_rules {
        network_entity_id   = oci_core_drg.drg1.id
        destination          = oci_core_vcn.vcn3.cidr_blocks[0]
    }
}

resource "oci_core_route_table" "privateRT2" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn2.id
    display_name    = "PrivateRT2"

    route_rules {
        network_entity_id   = oci_core_nat_gateway.nat2.id
        destination          = "0.0.0.0/0"
    }
    
    route_rules {
        network_entity_id   = oci_core_local_peering_gateway.lpg2.id
        destination          = oci_core_vcn.vcn1.cidr_blocks[0]
    }

    route_rules {
        network_entity_id   = oci_core_local_peering_gateway.lpg2.id
        destination          = oci_core_vcn.vcn3.cidr_blocks[0]
    }
}

resource "oci_core_local_peering_gateway" "lpg1" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn1.id

    display_name    = "LPG1-LPG2"
}

resource "oci_core_local_peering_gateway" "lpg2" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn2.id

    display_name    = "LPG2-LPG1"
    peer_id         = oci_core_local_peering_gateway.lpg1.id
}

resource "oci_core_security_list" "publicSL1" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn1.id

    display_name = "PublicSL1"

    ingress_security_rules {
        protocol    = "all"
        source      = "0.0.0.0/0"
    }

    egress_security_rules {
        destination     = "0.0.0.0/0"
        protocol        = "all"
    }
}

resource "oci_core_security_list" "publicSL2" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn2.id
    display_name    = "PublicSL2"

    ingress_security_rules {
        protocol    = "all"
        source      = "0.0.0.0/0"
    }

    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol    = "all"
    }
}

resource "oci_core_security_list" "privateSL1" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn1.id
    display_name    = "PrivateSL1"

    ingress_security_rules {
        protocol    = "all"
        source      = oci_core_vcn.vcn1.cidr_blocks[0]
    }

    ingress_security_rules {
        protocol    = "all"
        source      = oci_core_vcn.vcn2.cidr_blocks[0]
    }

    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol    = "all"
    }
}

resource "oci_core_security_list" "privateSL2" {

    compartment_id  = var.compartment_ocid
    vcn_id          = oci_core_vcn.vcn2.id
    display_name    = "PrivateSL2"

    ingress_security_rules {
        protocol    = "all"
        source      = oci_core_vcn.vcn1.cidr_blocks[0]
    }

     ingress_security_rules {
        protocol    = "all"
        source      = oci_core_vcn.vcn2.cidr_blocks[0]
    }

    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol    = "all"
    }
}

resource "oci_core_subnet" "publicsubnet1" {

    cidr_block          = "10.0.0.0/24"
    compartment_id      = var.compartment_ocid
    vcn_id              = oci_core_vcn.vcn1.id
    display_name        = "PublicSubnet1"
    route_table_id      = oci_core_route_table.publicRT1.id
    security_list_ids   = [oci_core_security_list.publicSL1.id]
}

resource "oci_core_subnet" "privatesubnet1" {

    cidr_block          = "10.0.1.0/24"
    compartment_id      = var.compartment_ocid
    vcn_id              = oci_core_vcn.vcn1.id
    display_name        = "PrivateSubnet1"
    route_table_id      = oci_core_route_table.privateRT1.id
    security_list_ids   = [oci_core_security_list.privateSL1.id]
    prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_subnet" "publicsubnet2" {

    cidr_block          = "10.1.0.0/24"
    compartment_id      = var.compartment_ocid
    vcn_id              = oci_core_vcn.vcn2.id
    display_name        = "PublicSubnet2"
    route_table_id      = oci_core_route_table.publicRT2.id
    security_list_ids   = [oci_core_security_list.publicSL2.id]
}

resource "oci_core_subnet" "privatesubnet2" {

    cidr_block          = "10.1.1.0/24"
    compartment_id      = var.compartment_ocid
    vcn_id              = oci_core_vcn.vcn2.id
    display_name        = "PrivateSubnet2"
    route_table_id      = oci_core_route_table.privateRT2.id
    security_list_ids   = [oci_core_security_list.privateSL2.id]
    prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_cpe" "cpe-pfsense" {

    compartment_id = var.compartment_ocid
    ip_address = oci_core_instance.pfsense.public_ip
    display_name = "pfsense"
}

resource "oci_core_ipsec" "ipsec-pfsense" {

    #Required
    compartment_id = var.compartment_ocid
    cpe_id = oci_core_cpe.cpe-pfsense.id
    drg_id = oci_core_drg.drg1.id
    static_routes = oci_core_vcn.vcn3.cidr_blocks
    display_name = "ipsec-pfsense"
}


