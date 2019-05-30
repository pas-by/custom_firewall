#!/bin/bash
#
#  file name : custom_firewall_001.sh
#
#  turn off UFW completely and delete all the rules
sudo ufw reset

#  deny ICMP ping requests
sudo sed -i '/ufw-before-input.*icmp/s/ACCEPT/DROP/g' /etc/ufw/before.rules
#

#  start it again
sudo ufw enable

#  custom rules
#
#  define user address
array=( 10.66.13.0/24
        10.66.34.0/24
        10.66.207.0/24 )
for i in "${array[@]}"
do
        #  allow HTTP & HTTPS
	sudo ufw allow proto tcp from $i to any port 80,443
done

#
#  define admin address
array=( 10.66.13.0/24 )
for i in "${array[@]}"
do
        #  allow SSH
        sudo ufw limit proto tcp from $i to any port 22
        #  allow SAMBA
        sudo ufw allow proto tcp from $i to any port 139,445
        sudo ufw allow proto udp from $i to any port 137,138
        #  allow MySQL
        sudo ufw allow proto tcp from $i to any port 3306
done
