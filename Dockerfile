ARG DOCKER_REPO=macwinnie
ARG DOCKER_IMG=apache
ARG DOCKER_VERSION=latest

FROM ${DOCKER_REPO}/${DOCKER_IMG}:${DOCKER_VERSION}
MAINTAINER macwinnie <dev@macwinnie.me>
MAINTAINER Felix Kazuya <dev@felixkazuya.de>

ENV RUNTIMEFOLDER="/var/www/limesurvey"

RUN wget $( curl -L https://community.limesurvey.org/downloads/ | sed -n "s/.*'\(.*lts.*\.zip\)'.*/\1/p" ) -O /tmp/limesurvey.zip 

RUN unzip /tmp/limesurvey.zip -d /tmp/ 
RUN mv /tmp/limesurvey /tmp/html && \
    mv /tmp/html "${APACHE_WORKDIR}/.."
RUN rm -rf /tmp/*

COPY files/templates/* /templates/
COPY files/install.sh /boot.d/

RUN update-ca-certificates

# run on every (re)start of container
ENTRYPOINT ["entrypoint"]
CMD ["apache2-foreground"]
