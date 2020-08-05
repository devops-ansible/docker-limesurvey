ARG DOCKER_REPO=macwinnie
ARG DOCKER_IMG=apache
ARG DOCKER_VERSION=latest

FROM ${DOCKER_REPO}/${DOCKER_IMG}:${DOCKER_VERSION}
MAINTAINER macwinnie <dev@macwinnie.me>

ENV RUNTIMEFOLDER="/var/www/limesurvey"

ARG LIMESURVEY_DL_URL="https://download.limesurvey.org/lts-releases/limesurvey3.22.210+200804.zip"

RUN  wget "${LIMESURVEY_DL_URL}" -O /tmp/limesurvey.zip
RUN unzip /tmp/limesurvey.zip -d /tmp/ 
RUN mv /tmp/limesurvey "${APACHE_WORKDIR}"
RUN rm -rf /tmp/*

COPY files/templates/* /templates/
COPY files/install.sh /boot.d/

RUN update-ca-certificates

# run on every (re)start of container
ENTRYPOINT ["entrypoint"]
CMD ["apache2-foreground"]
