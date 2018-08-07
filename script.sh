#!/bin/bash

ProjectName="project name"

# provide path of openrc file for an admin user to be sourced 
source admin-openrc

openstack project create --domain default $ProjectName

openstack role add --project $ProjectName --user admin user

#provide basic quotas to be set for project
#you can add more variables
openstack quota set --ram 10240 --cores 80 --instances 40 --volumes 40 --gigabytes 2000 $ProjectName

neutron quota-update --floatingip  5 --security-group 5  --tenant-id $(openstack  project show $ProjectName -c id -f value)

#replace password here with actual admin password
openstack security group rule create --proto icmp default --os-project-name $ProjectName --os-username admin --os-password password --os-project-name $ProjectName --os-project-domain-name default --os-user-domain-name default --os-auth-url http://controller:35357/v3

openstack security group rule create --proto tcp --dst-port '1:65535' default --os-project-name $ProjectName --os-username admin --os-password password --os-project-name $ProjectName --os-project-domain-name default --os-user-domain-name default --os-auth-url http://controller:35357/v3


neutron net-create internal_$ProjectName  --os-project-name $ProjectName --os-username admin --os-password password --os-project-name $ProjectName --os-project-domain-name default --os-user-domain-name default --os-auth-url http://controller:35357/v3

#you may use 'openstack subnet create' here
neutron subnet-create --name subnet_$ProjectName --dns-nameserver 172.30.30.250 --dns-nameserver 8.8.8.8 internal_$ProjectName "192.168.0.0/24" --os-project-name $ProjectName --os-username admin --os-password password --os-project-name $ProjectName --os-project-domain-name default --os-user-domain-name default --os-auth-url http://controller:35357/v3

neutron router-create router_$ProjectName  --os-project-name $ProjectName --os-username admin --os-password password --os-project-name $ProjectName --os-project-domain-name default --os-user-domain-name default --os-auth-url http://controller:35357/v3

neutron router-interface-add router_$ProjectName subnet_$ProjectName --os-project-name $ProjectName --os-username admin --os-password password --os-project-name $ProjectName --os-project-domain-name default --os-user-domain-name default --os-auth-url http://controller:35357/v3

neutron router-gateway-set router_$ProjectName public --os-project-name $ProjectName --os-username admin --os-password password --os-project-name $ProjectName --os-project-domain-name default --os-user-domain-name default --os-auth-url http://controller:35357/v3


