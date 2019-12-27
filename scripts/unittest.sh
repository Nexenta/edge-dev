#!/bin/bash

#  SYNOPSIS:
#  This script will check the cluster health on all the nodes. Run this script individully on all the nodes where cluster is installed.
#    


#globals
alias neadm="docker run -i -t --rm --network host nexenta/nedge-neadm /opt/neadm/neadm"
chmod 755 /root/c0/nesetup.json
BROKER_INTERFACE=`cat /root/c0/nesetup.json | grep broker | awk '{print $2}' | sed 's/"//g'`
SERVER_INTERFACE=`cat /root/c0/nesetup.json | grep server | awk '{print $2}' | sed 's/"//g'`
DISKLIST=`cat /root/c0/nesetup.json | grep  /dev | awk '{print $2}' | sed 's/"//g'`

#This function checks following things
# 1. Host operating system
# 2. nedge-core version
# 3. NIC speed for the interfaces mentioned in nesetup.json
check_system_status(){    

#Operating system chheck

    echo -e "\e[1;32mChecking system status..."

    if [ -f /etc/lsb-release ] && grep -q 16.04 /etc/lsb-release
    then 
	    echo -e "\e[1;32mOperating System:          Ubuntu 16.04.1 LTS[OK]\e[0m"

    elif [ -f /etc/centos-release ] && grep -q "7.2" /etc/centos-release
    then
        echo -e "\e[1;32mOperating System:          CentOS7.2\e[0m"
    
    else
    	echo -e "\e[1;31mYou need Ubuntu 16.04 or CentOS 7.2 platform for nedgedev[ERROR]\e[0m"
    fi

#check nedge-core version 
    VERSION=`docker exec -it nedge-data-s3 dpkg -l | grep -i nedge | awk '{print $3}'`
    echo -e "\e[1;32mNedge-Core version:        $VERSION"

#check NIC speed for the broker_interface and server_interface mentioned in nesetup.json
    BROKER_INTERFACE_SPEED=`ethtool $BROKER_INTERFACE | grep Speed  | awk '{print $2}'`
    SERVER_INTERFACE_SPEED=`ethtool $SERVER_INTERFACE | grep Speed  | awk '{print $2}'`
    echo -e "\e[1;32mbroker_interface speed:    $BROKER_INTERFACE_SPEED"
    echo -e "\e[1;32mserver_interface speed:    $SERVER_INTERFACE_SPEED"
}

#Check Total memory of the host
check_ram_size(){
    MEMSIZE=`free -g | head -2 | awk '{print $2}' | tail -1`
    if [ $MEMSIZE -lt 16 ]
    then
	    echo -e "\e[1;31mTotal Memory:              $MEMSIZE GB\e[0m"
    	echo -e "\e[1;31mMinimum RAM requirement:   16GB[WARNING]\e[0m"
    else 
	    echo -e "\e[1;32mTotal Memory:              $MEMSIZE GB\e[0m"
    fi
}

#Check Total Disk space of the raw disks mentioned in nesetup.json
check_disk_space(){
    SIZE=0
    for disk in $DISKLIST
    do
        CAPACITY=`parted -l  | grep /dev/sdb | awk '{print $3}' | sed 's/GB//g'`
        CAPACITY=${CAPACITY%.*}
        SIZE=$(($SIZE + $CAPACITY))
        if [ $CAPACITY -lt 40 ] 
	    then
		    echo -e "\e[1;31mThe recommended disk size: minimum 40GB[WARNING]"
            echo -e "\e[1;31m"$disk  "                 "  $CAPACITY "GB"
	    else
             echo -e "\e[1;32m"$disk  "                 "  $CAPACITY "GB" 
    fi 
    done
    echo -e "\e[1;32mTotal Disk Space:          $SIZE GB"
}

#check if the network interface is ipv6
is_nic_ipv6_check(){
    ip -6 addr | grep $BROKER_INTERFACE  > /dev/null
    EXIT_STATUS=`echo $?`
    if [ $EXIT_STATUS -ne 0 ] 
    then
	    echo "The broker interface mentioned in /root/c0/nesetup.json: not an IPV6 address.[ERROR]"
    fi

    ip -6 addr | grep $SERVER_INTERFACE > /dev/null
    EXIT_STATUS=`echo $?`
    if [ $EXIT_STATUS -ne 0 ] 
    then
	    echo "The server interface mentioned in /root/c0/nesetup.json: not an IPV6 address.[ERROR]"
    fi
}

#MTU size check for the  broker_interface and server_interface
#mentioned in nesetup.json
mtu_size(){

    FRAME_SIZE=`ip link show dev $BROKER_INTERFACE | grep mtu | awk '{print $5}'`
    if [ $FRAME_SIZE -ne 9000 ]
    then
        echo -e "\e[1;31The required frame size[MTU] for broker_interface: 9000.[ERROR]"
    else
        echo -e "\e[1;32mbroker_interface NIC MTU:  9000[OK]"
    fi

    FRAME_SIZE=`ip link show dev $SERVER_INTERFACE | grep mtu | awk '{print $5}'`
    if [ $FRAME_SIZE -ne 9000 ]
    then
        echo -e "\e[1;31The required frame size[MTU] for server_interface: 9000.[ERROR]"
    else
        echo -e "\e[1;32mserver_interface NIC MTU:  9000[OK]"
    fi
}

#check if the neadm cluster is ONLINE now
neadm_status(){
    NEADM_STATUS=`docker run -i -t --rm --network host nexenta/nedge-neadm /opt/neadm/neadm system status | grep "\`hostname\`:\`hostname\`" | awk '{print $(NF-1)}' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"`

    if [ "${NEADM_STATUS}" == 'ONLINE' ];
    then
	    echo -e "\e[1;32mneadm system status:       ONLINE[OK]\e[0m"
    else
	    echo -e "\e[1;31mThe neadm system:          NOT ONLINE[ERROR]\e[0m"
    fi
}

#check neadm services are running such as docker ccowgws3 auditserv ccowserv logger networkWorker restWorke
neadm_services(){

    echo -e "\e[1;32mChecking nedge services...\e[0m"
    for PROCESS in docker ccowgws3 auditserv ccowserv logger networkWorker restWorker 
    do
	    CHECK=$0
    	OUTPUT=$(ps aux | grep -v grep | grep -v $CHECK | grep $PROCESS)
	    if [ "${#OUTPUT}" -gt 0 ] 
    	then 
            printf "\e[1;32m%-26s running[OK]\n\e[0m" ${PROCESS}:
	    else 
		    printf "\e[1;32m%-26s service:NOT running[ERROR]\n\e[0m" ${PROCESS}:
	    fi
    done
}
main(){
    
    check_system_status
    check_ram_size
    check_disk_space
    is_nic_ipv6_check
    mtu_size
    neadm_status
    neadm_services   
}
main "$@"
