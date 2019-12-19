#!/bin/bash

#run with [bash ./script.sh]

#check if root (i.e.: for installing packages)
if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

mkdir /home/vtpm
chmod ugoa+rwx -R /home/vtpm
# $src=/home/vtpm                                       # fix something to use $variabels.

read -rsp $'Press any key to continue...\n' -n1 key

# Install dependent packages 
sudo apt-get update -y
sudo apt-get -y install automake expect gnutls-bin libgnutls28-dev git gawk m4 socat fuse libfuse-dev tpm-tools libgmp-dev libtool libglib2.0-dev libnspr4-dev libnss3-dev libssl-dev libtasn1-6-dev net-tools libseccomp-dev

read -rsp $'Press any key to continue...\n' -n1 key

# Download libtpms and swtpm code from github and compile

#libtpm part:
git clone https://github.com/stefanberger/libtpms.git /home/vtpm/libtpms   
cd /home/vtpm/libtpms
./bootstrap.sh
./configure  --with-openssl --with-tpm2 &&                     # support TPM2.0
sudo make &&
sudo make install                                               # optional

echo "libtpm finished"
read -rsp $'Press any key to continue...\n' -n1 key

#swtpm part:
git clone https://github.com/stefanberger/swtpm.git /home/vtpm/swtpm
cd /home/vtpm/swtpm
./autogen.sh &&
./configure  --prefix=/usr --with-openssl --with-tpm2 &&
sudo make &&
sudo make install                                             #optional

echo "done with swtpm"
cd /home/vtpm
read -rsp $'Press any key to continue...\n' -n1 key

#archiving folders
tar -zcvf /home/vtpm/libtpms.tar.gz /home/vtpm/libtpms
read -rsp $'Press any key to continue...\n' -n1 key
tar -zcvf /home/vtpm/swtpm.tar.gz /home/vtpm/swtpm

echo "finished"
