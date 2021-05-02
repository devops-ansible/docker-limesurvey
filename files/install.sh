#!/bin/bash

wget $(curl -L https://community.limesurvey.org/downloads/ | sed -n "s/.*'\(.*lts.*\.zip\)'.*/\1/p") -O /tmp/limesurvey.zip

unzip /tmp/limesurvey.zip -d /tmp/

mv  /tmp/limesurvey  /tmp/html
mv  /tmp/html        "${APACHE_WORKDIR}"/..
rm  -rf  /tmp/*

mv  /docker_install/templates               /templates
mv  /docker_install/01_install_on_start.sh  /boot.d/
rm  -rf  /docker_install
