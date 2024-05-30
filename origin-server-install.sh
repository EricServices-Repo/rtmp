#!/usr/bin/env bash
#EricServic.es RTMP Origin Server Install
#
# Installs:
# Nginx
# Nginx RTMP module
# SQL DB
# HTTP Admin Portal
#
##### Variables ###############################
# ESREPO - EricServic.es Repo
# CERTBOT - Toggle for Installing Certbot
# SQLPASSWORD - MySQL Root Password
# INGESTSERVERIP Ingest Server IP Addresses
###############################################

#################
# Define Colors #
#################
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"


echo -e "${GREEN}EricServic.es Email Server Build${ENDCOLOR}"

echo -e "${BLUE} ______      _       _____                 _                    ${ENDCOLOR}"  
echo -e "${BLUE}|  ____|    (_)     / ____|               (_)                   ${ENDCOLOR}"
echo -e "${BLUE}| |__   _ __ _  ___| (___   ___ _ ____   ___  ___   ___  ___    ${ENDCOLOR}"
echo -e "${BLUE}|  __| | '__| |/ __|\___ \ / _ \ '__\ \ / / |/ __| / _ \/ __|   ${ENDCOLOR}"
echo -e "${BLUE}| |____| |  | | (__ ____) |  __/ |   \ V /| | (__ |  __/\__ \   ${ENDCOLOR}"
echo -e "${BLUE}|______|_|  |_|\___|_____/ \___|_|    \_/ |_|\___(_)___||___/ \n${ENDCOLOR}"


#####################
# Set all Variables #
#####################
echo -e "${GREEN}Set Variables for custom install.${ENDCOLOR}"

read -p "Use EricServic.es Repository [y/N]:" ESREPO
ESREPO="${ESREPO:=n}"
echo "$ESREPO"

read -p "Install Certbot? (s:Staging) [y/N/s]:" CERTBOT
CERTBOT="${CERTBOT:=n}"
echo "$CERTBOT"

read -p "Set MySQL root PASSWORD [testing]:" SQLPASSWORD
SQLPASSWORD="${SQLPASSWORD:=testing}"
echo "$SQLPASSWORD"

read -p "List all Ingest Server IP Addresses[172.16.1.10,172.16.1.20]:" INGESTSERVERIP
INGESTSERVERIP="${INGESTSERVERIP:=172.16.1.10}"
echo "$INGESTSERVERIP"




############################
# Local EricServic.es Repo #
############################
if [[ "$ESREPO" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
    echo -e "${GREEN}Configure the EricServic.es Local Repository.${ENDCOLOR}"
    sleep 1

    LOCALREPO_FILE=/etc/yum.repos.d/localrepo.repo
    if test -f "$LOCALREPO_FILE"; then
        echo -e "$LOCALREPO_FILE already exists, no need to create.\n"
    fi

    if [ ! -f "$LOCALREPO_FILE" ]
    then 
        echo -e "$LOCALREPO_FILE does not exist, creating it.\n"
        cat << EOF >> /etc/yum.repos.d/localrepo.repo
        [localrepo-base]
        name= Local RockyLinux BaseOS
        baseurl=http://mirror.ericembling.me/rocky-linux/\$releasever/BaseOS/\$basearch/os/
        gpgcheck=0
        enabled=1
        [localrepo-appstream]
        name=Local RockyLinux AppStream
        baseurl=http://mirror.ericembling.me/rocky-linux/\$releasever/AppStream/\$basearch/os/
        gpgcheck=0
        enabled=1
        EOF
    fi

    echo -e "${GREEN}Move old Rocky Linux Repos so they are not used.\n${ENDCOLOR}"
    sleep 1

    ROCKYBASEOS_FILE=/etc/yum.repos.d/Rocky-BaseOS.repo.old
    ROCKYAPPSTREAM_FILE=/etc/yum.repos.d/Rocky-AppStream.repo.old

    if test -f "$ROCKYBASEOS_FILE"; then
        echo -e "$ROCKYBASEOS_FILE already exists, no need to move.\n"
    fi

    if [ ! -f "$ROCKYBASEOS_FILE" ]
    then 
        mv /etc/yum.repos.d/Rocky-BaseOS.repo /etc/yum.repos.d/Rocky-BaseOS.repo.old
    fi

    if test -f "$ROCKYAPPSTREAM_FILE"; then
        echo -e "$ROCKYAPPSTREAM_FILE already exists, no need to move.\n"
    fi

    if [ ! -f "$ROCKYAPPSTREAM_FILE" ]
    then 
        mv /etc/yum.repos.d/Rocky-AppStream.repo /etc/yum.repos.d/Rocky-AppStream.repo.old
    fi

fi


################################
# Updates + Install + Firewall #
################################
echo -e "${GREEN}Process updates and install${ENDCOLOR}"
sleep 1

echo -e "Yum Update"
yum update -y

echo -e "Install epel-release"
yum install epel-release -y



