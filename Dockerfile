FROM node:10.5.0-alpine

LABEL authors="Dmitry Erman <dmitry.erman@gmail.com>"
LABEL maintainer="Dmitry Erman <dmitry.erman@gmail.com>"

ARG DOCKER_CLI_VERSION="17.06.2-ce"
ENV DOWNLOAD_URL="https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz"

# Base APK installs
RUN apk --no-cache add --update \
  python \
  python-dev \
  py-pip \
  build-base \
  alpine-sdk \
  bash git openssh \
  curl zip sshpass rsync

RUN pip install --upgrade pip

# install AWS Client
RUN pip install awscli
#install AWS ECS deploy script
RUN pip install -U boto
RUN pip install ecs-deploy

# docker setup
RUN mkdir -p /tmp/download \
    && curl -L $DOWNLOAD_URL | tar -xz -C /tmp/download \
    && mv /tmp/download/docker/docker /usr/local/bin/ \
    && rm -rf /tmp/download


# Angular Setup for 1.5.6 client
RUN yarn global add @angular/cli@1.5.6

RUN ng set --global packageManager=yarn \
  && apk del alpine-sdk \
  && rm -rf /tmp/* /var/cache/apk/* *.tar.gz ~/.npm \
  && npm cache clean --force \
  && yarn cache clean \
  && sed -i -e "s/bin\/ash/bin\/sh/" /etc/passwd
