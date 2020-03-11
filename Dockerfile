FROM node:13.6-alpine

LABEL authors="Dmitry Erman <dmitry.erman@gmail.com>"
LABEL maintainer="Dmitry Erman <dmitry.erman@gmail.com>"

ARG DOCKER_CLI_VERSION="19.03.5"
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
RUN apk add jq

# docker setup
RUN mkdir -p /tmp/download \
    && curl -L $DOWNLOAD_URL | tar -xz -C /tmp/download \
    && mv /tmp/download/docker/docker /usr/local/bin/ \
    && rm -rf /tmp/download


# Angular Setup for 9.0.5 client
RUN yarn global add @angular/cli@9.0.5

RUN apk del alpine-sdk \
  && rm -rf /tmp/* /var/cache/apk/* *.tar.gz ~/.npm \
  && npm cache clean --force \
  && yarn cache clean
