// Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0

// Copyright (c) 2017, 2020, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Mozilla Public License v2.0


variable "compartment_ocid" {
    #vitor_pinto/advanced_networks
    default = "ocid1.compartment.oc1..aaaaaaaaairdi54qvbrrvhemj4o3qqdgxyn7gg5qizzc3ggxvmhhe2us2vea"
}

variable "region" {
    default = "us-phoenix-1"
}

variable "ol_image_ocid" {
  type = map(string)

  default = {
    # Oracle Linux 8.2 See https://docs.cloud.oracle.com/en-us/iaas/images/image/6008098c-c384-41fe-8880-c39baa48f772/"
    ap-chuncheon-1   = "ocid1.image.oc1.ap-chuncheon-1.aaaaaaaatkfdgmbbnlakyimn6npb2ewqght3kn24sirn7jeokatwgbnhdafa"
    ap-hyderabad-1   = "ocid1.image.oc1.ap-hyderabad-1.aaaaaaaagh53qwdyaugoumhcf5femmwiybihoj5hnlds5kutymoimqcdc2vq"
    ap-melbourne-1   = "ocid1.image.oc1.ap-melbourne-1.aaaaaaaabpm7kgxombheohs2vejvvkjoqtwvdmtfw4x33djit2r5nbpg2vrq"
    ap-mumbai-1      = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaanb2hr3astngvmjd6dnka5mgnccztbikqstfw3od3rwxbr2wopd3q"
    ap-osaka-1       = "ocid1.image.oc1.ap-osaka-1.aaaaaaaaemisrqvxcj53tme72mhdv67shu6522xp7njtk4q2v2okk5pkycaa"
    ap-seoul-1       = "ocid1.image.oc1.ap-seoul-1.aaaaaaaazgc4eabvujnwxig22gw3hp36sd7cfdgtqy4akrbmwpp5ze3zbakq"
    ap-sydney-1      = "ocid1.image.oc1.ap-sydney-1.aaaaaaaa6uxnc2pocssbr4hmzrgimichwo67yrb5ubw3mgpte7vnyyxnkwpa"
    ap-tokyo-1       = "ocid1.image.oc1.ap-tokyo-1.aaaaaaaa2heyrjlau3qsb2u3d52dwmyf6oyvpnacbo6iqdy3hgmskz566h4q"
    ca-montreal-1    = "ocid1.image.oc1.ca-montreal-1.aaaaaaaadv6wkwr7yacvdhtlr7j4nkr3j4rs22prh62qwe5qtpb4dfoqwkeq"
    ca-toronto-1     = "ocid1.image.oc1.ca-toronto-1.aaaaaaaan7vf5ly6f73lb3y73nmyv35nbggfeukjlpg4zkqwvskhmjdgutoa"
    eu-amsterdam-1   = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaapmpgky3vllousfv3mw65vlgfikfncsoeppur2c5yiz5xq3zoalva"
    eu-frankfurt-1   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa5wspx2ktu23r2cqe2obj5lk4o73hongcxm4uxteyobcx4v7yxv5q"
    eu-zurich-1      = "ocid1.image.oc1.eu-zurich-1.aaaaaaaanu5pmvv6nfwnswzupqhkf5dwn2bm6lz7yvi62ybqqaflpsc6q35q"
    me-dubai-1       = "ocid1.image.oc1.me-dubai-1.aaaaaaaawj3pt2rww54smhrc6n7glzudtaisnotzyncdxlpwsn43ivvnw3gq"
    me-jeddah-1      = "ocid1.image.oc1.me-jeddah-1.aaaaaaaaegkd6xigtwpk6c4clwzc5glfy42vx3c3vm5y5vf6xldzd55uoaua"
    sa-saopaulo-1    = "ocid1.image.oc1.sa-saopaulo-1.aaaaaaaagxoe7cvwkdzrs5ajxoyjhdyyiuuvqs6lovlaguntv6eh2goalliq"
    uk-cardiff-1     = "ocid1.image.oc1.uk-cardiff-1.aaaaaaaax4l33gurntsu6r76afpdvowxcuuyighz74fr3yljf6kfgdbqcdla"
    uk-london-1      = "ocid1.image.oc1.uk-london-1.aaaaaaaadrdgfobwkknwabs4sfczwfsgvh4lu5twvfhwdu22okrcizamkaia"
    us-ashburn-1     = "ocid1.image.oc1.iad.aaaaaaaak6gcgvlv3rgnrtztshfybjhbnarc5yakiunl2uu4bdadbmkqsf7q"
    us-gov-ashburn-1 = "ocid1.image.oc3.us-gov-ashburn-1.aaaaaaaary6jtyjup7d5n3w3lgstqomg3dm26wpacnhatiscdbp5cylsrija"
    us-gov-chicago-1 = "ocid1.image.oc3.us-gov-chicago-1.aaaaaaaaxudzchohuiwbm6jjq2b4gv5h5aet7vkossp76h7nen37ou2uspoa"
    us-gov-phoenix-1 = "ocid1.image.oc3.us-gov-phoenix-1.aaaaaaaa4qcv62mqicvz7kj4p2mow7txalznt6gexllt5kea6trzazxzr2ra"
    us-langley-1     = "ocid1.image.oc2.us-langley-1.aaaaaaaa72gn445fgymudnps6w75hfpgln45ega4rh64assb3w46o67mxbra"
    us-luke-1        = "ocid1.image.oc2.us-luke-1.aaaaaaaahrocwywdal55z27vtjavlzpuedijpyccuycar7gnlleugmvwac5q"
    us-phoenix-1     = "ocid1.image.oc1.phx.aaaaaaaacoipckanba22joksjifv5g7mvj72wp4yh7epvxjvsfmfcrty5j4a"
    us-sanjose-1     = "ocid1.image.oc1.us-sanjose-1.aaaaaaaanq44gnx6hfgsaug7otrxvvkeimtl76t5qk76yxb7plwhuzvxiw3q"
  }
}

variable "instance_shape" {
    default = "VM.Standard2.1"
}

data "oci_identity_availability_domain" "ad" {
    compartment_id  = var.tenancy_ocid
    ad_number       = "1"
}

variable "tenancy_ocid" {
  #brztechcloud01
  default = "ocid1.tenancy.oc1..aaaaaaaakankmz2x3rclvsqfxvro7f6iar2cowvb6inb7pe5th7fmxthrigq"

}

variable "user_ocid" {
  #oracleidentitycloudservice/vitor.pinto@oracle.com
  default = "ocid1.user.oc1..aaaaaaaa7pbbpakvbyqu4msizhkxotbvpmp2rqevpd7bjutz2slr574sh5vq"

}

variable "fingerprint" {
  default = "9d:fa:0a:00:88:31:43:f9:cf:a4:fe:f0:fd:dd:e4:64"
}

variable "private_key_path" {
  default = "C:\Users\vitorp\Desktop\SSH\API\apikey"
}

variable "token" {
  default = "c<vj0;5!_gco5Dnk3>WH"
}

variable "ssh_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAr+LqZXg2RP2JBz+BLu4U99LHtTf8kLST7yVa8JKI3d+s/efT76qhPItvc/y3I514FivRs3Vu+iaZXvaZOMJW/PmVelEh9N39tqSNqs4wHi+fT8BRfaEG9XsL6iniOHNuT4jLRbDZhg6Hr16/vHDo7kRDVYzuQoyvFx0ONj/XEDGuHfJ0NdRifNmVLSfkNnDsPmAqwDM2K1GDuGbht55LgY8jmO9l0iD9vmeE01dQV2O1LVk5modyiRT6/0VF56oKQe7JEQYvgvM2Xe9MkVYMheOk5rLzNsIxwvMJ+eUmEmBM4VM7gGJezAVJbICXfY+0J/rVVltZU37IKBMe12rpxw== rsa-key-20210112"
}


provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
