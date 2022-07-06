#!/bin/bash

arch=$(uname -a)
pcpu=$(grep  "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)
muse=$(free --mega | grep Mem | awk '{print $3}')
mtot=$(free --mega | grep Mem | awk '{print $2}')
mper=$(free --mega | grep Mem | awk '{printf("%.2f"), $3*100/$2}')
duse=$(df -Bm | grep '^/dev/' | grep -v '/boot' | awk '{x += $3} END {print x}')
ddis=$(df -Bg | grep '^/dev/' | grep -v '/boot' | awk '{y += $4} END {print y}')
dper=$(df -Bm | grep '^/dev/' | grep -v '/boot' | awk '{x += $3} {y += $4} END {printf("%.2f"), x*100/y}')
cpul=$(top -bn1 | grep '%Cpu' | awk '{printf("%.1f"), $2}')
lbot=$(who -b   | awk '{print $4 " " $5}')
lvmu=$(lsblk    | grep lvm | wc -l | awk '{if ($1 > 0) {print "yes";exit;} else {print "no" } }')
ctcp=$(ss -t | grep ESTAB | wc -l | awk '{if ($1 > 0) {print $1 " ESTABLISHED";exit;} else {print "no"} }')
ulog=$(who | awk '{print $1}' | sort -u | wc -l)
netw=$(hostname -I)
nmac=$(ip a | grep ether | awk '{print $2}')
nsud=$(journalctl _COMM=sudo -q | grep COMMAND | wc -l)

wall "
#Architecture:   $arch
#CPU Physical:   $pcpu
#vCPU:           $vcpu
#Memory Usage:   $muse/${mtot}MB ($mper%)
#Disk Usage:     ${duse}MB/${ddis}GB ($dper%)
#CPU Load:       ${cpul}%
#Last Boot:      $lbot
#LVM Use:        $lvmu
#Connexions TCP: $ctcp
#User Log:       $ulog
#Network:        IP $netw $nmac
#sudo:           $nsud

" 
