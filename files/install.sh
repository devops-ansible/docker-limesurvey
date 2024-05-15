#!/usr/bin/env bash

set -eu -o pipefail

wget "$( curl -L https://community.limesurvey.org/downloads/ | sed -n "s/.*'\(.*latest-master.*\.zip\)'.*/\1/pI" )" -O /tmp/limesurvey.zip

unzip /tmp/limesurvey.zip -d /tmp/

mv  /tmp/limesurvey  /tmp/html
mv  /tmp/html        "${APACHE_WORKDIR}"/..
rm  -rf  /tmp/*

mv  /docker_install/templates/*             /templates/
mv  /docker_install/10_install_on_start.sh  /boot.d/
rm  -rf  /docker_install

chown -R www-data:www-data "${APACHE_WORKDIR}"
