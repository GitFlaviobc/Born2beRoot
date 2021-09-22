#!/bin/bash

arc=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
fram=$(free -m | awk '$1 == "Mem:" {print $2}')
uram=$(free -m | awk '$1 == "Mem:" {print $3}')
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
fdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
pdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
cpul=$(mpstat | awk 'END {printf("%.2f", 100 - $NF)}')
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvmt=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(netstat -ant | grep ESTABLISHED | wc -l)
ulog=$(who | wc -l)
ip=$(hostname -I | awk '{print $1}')
mac=$(ip a | awk '$1 == "link/ether" {print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "	#Architecture: $arc
	                    #CPU physical: $pcpu
	                    #vCPU: $vcpu
	                    #Memory Usage: $uram/${fram}MB ($pram%)
	                    #Disk Usage: $udisk/${fdisk}Gb ($pdisk%)
	                    #CPU load: $cpul
	                    #Last boot: $lb
	                    #LVM use: $lvmu
	                    #Connexions TCP: $ctcp ESTABLISHED
	                    #User log: $ulog
	                    #Network: IP $ip ($mac)
	                    #Sudo: $cmds cmd"