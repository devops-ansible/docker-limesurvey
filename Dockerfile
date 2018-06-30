ARG DOCKER_REPO=macwinnie
ARG DOCKER_IMG=apache
ARG DOCKER_VERSION=php7.2

FROM ${DOCKER_REPO}/${DOCKER_IMG}:${DOCKER_VERSION}
MAINTAINER macwinnie <dev@macwinnie.me>

ENV RUNTIMEFOLDER="/var/www/limesurvey"

RUN wget 'https://www.limesurvey.org'$( curl -L https://www.limesurvey.org/stable-release | sed -n 's/.*"\(.*targz\)".*/\1/p' ) -O /tmp/limesurvey.tar.gz
RUN tar xfz /tmp/limesurvey.tar.gz --strip=1 -C "${APACHE_WORKDIR}"
RUN rm -f /tmp/limesurvey.tar.gz

COPY files/templates/* /templates/
COPY files/install.sh /boot.d/

RUN update-ca-certificates

# run on every (re)start of container
ENTRYPOINT ["entrypoint"]
CMD ["apache2-foreground"]
