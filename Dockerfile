FROM alpine:3.15

# https://github.com/hypnoglow/helm-s3
ENV HELM_S3_PLUGIN_VERSION "0.10.0"

# set some defaults
ENV AWS_DEFAULT_REGION "us-east-1"
ARG DEBIAN_FRONTEND=noninteractive


# install nodejs from https://github.com/mhart/alpine-node/blob/master/Dockerfile
ENV VERSION=v12.4.0 NPM_VERSION=6 YARN_VERSION=latest

RUN apk add --no-cache curl make gcc g++ python3 linux-headers binutils-gold gnupg libstdc++ && \
  for PUBKEY in $(apt-get update 2>&1 | grep NO_PUBKEY | awk '{print $NF}') ; do \
    wget -q "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x${PUBKEY}" -O - | sed -n '/BEGIN/,/END/p' | apt-key add - 2>/dev/null ; \
  done && \
  apk add --update nodejs npm && \

  apk del curl make gcc g++ linux-headers binutils-gold gnupg ${DEL_PKGS} && \
  rm -rf ${RM_DIRS} /node-${VERSION}* /SHASUMS256.txt /usr/share/man /tmp/* /var/cache/apk/* \
    /root/.npm /root/.node-gyp /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html /usr/lib/node_modules/npm/scripts && \
  { rm -rf /root/.gnupg || true; }

RUN npm install -g yarn

# Install awscli
RUN apk -Uuv add groff less py-pip gettext \
    && pip install awscli \
    && apk --purge -v del py-pip

COPY install.sh /opt/install.sh
RUN /opt/install.sh

CMD bash
