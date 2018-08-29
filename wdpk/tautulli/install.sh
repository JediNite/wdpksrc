#!/bin/bash

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

INSTALL_DIR=$1
NAS_PROG=$2

log=/tmp/debug_apkg

APKG_MODULE="tautulli"
APKG_PATH="${path_dst}/${APKG_MODULE}"
APKG_CONFIG="${APKG_PATH}/config.ini"
APKG_CONFIG_BACKUP="/mnt/HD/HD_a2/.systemfile/{APKG_MODULE}.ini"
DATA_DIR="${APKG_PATH}/data"
DATA_DIR_BACKUP="/mnt/HD/HD_a2/.systemfile/{APKG_MODULE}_data"

# install all package scripts to the proper location
cp -rf ${INSTALL_DIR} ${NAS_PROG}

# setup secure downloads
curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
mv cacert.pem /etc/ssl/cert.pem

# install pip to get pkg_resources module
/opt/bin/opkg install python-light python-pip git git-http

# get the Tautulli source code
/opt/bin/git clone https://github.com/Tautulli/Tautulli.git

# restore config
if [ -f ${APKG_CONFIG_BACKUP} ]; then
  echo "Restore ${APKG_MODULE} config"
  cp ${APKG_CONFIG_BACKUP} ${APKG_CONFIG}
  cp -r ${DATA_DIR_BACKUP} ${DATA_DIR}
fi

echo "Addon ${APKG_MODULE} (install.sh) done" >> $log

