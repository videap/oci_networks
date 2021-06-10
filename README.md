# oci

##This branch creates:

#REGION SAO PAULO


##Compartment vitor_pinto  
None

##Compartment Advanced_Networks  
vcn1
vcn2 + peering with vcn1

#############################################################################
#REGION ASHBURN


##Compartment Advanced_Networks 
vcn1 +  DRG + VPN Connection
vcn2 + peering with vcn1
vcn3 + pfSense
vcn4 + peering with vcn3
pfSense and Jumper in vcn3
2 Private VMs in vcn4


##Compartment vitor_pinto  
vcn_sp1   
Public Intance VM1-Public-SP & Install Webserver  
LB - NOT READY