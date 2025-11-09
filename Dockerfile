ARG DOCKER_REPO=devopsansiblede
ARG DOCKER_IMG=apache
ARG DOCKER_VERSION=latest

FROM ${DOCKER_REPO}/${DOCKER_IMG}:${DOCKER_VERSION}
MAINTAINER macwinnie <dev@macwinnie.me>

ENV RUNTIMEFOLDER="/var/www/limesurvey"

COPY files /docker_install
RUN  chmod a+x /docker_install/install.sh && \
     /docker_install/install.sh

# run on every (re)start of container
ENTRYPOINT ["entrypoint"]
CMD ["apache2-foreground"]
