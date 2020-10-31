FROM python:3.8-alpine

ARG ARCH=amd64
ARG S6_OVERLAY_VERSION=v2.1.0.2

ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${ARCH}.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-${ARCH}.tar.gz | tar -xf - -C /
ENTRYPOINT ["/init"]

COPY etc/ /etc
COPY patches/ /patches
COPY scripts/ /usr/local/bin

RUN apk --no-cache update && apk add --no-cache \
        patch \
        bash \
        git \
        rsync \
        cdrkit \
    && apk add --no-cache --virtual=build-dependencies \
        build-base \
        gcc \
        libffi-dev \
        openssl-dev \
        libxml2-dev \
        libxslt-dev \
        python3-dev \
    && pip install --no-cache-dir -U pip flexget kinopoiskpy python-telegram-bot \
    && cd /usr/local/lib/python3.8/site-packages/flexget/components/tmdb \
    && patch -t -i /patches/tmdb_lookup.py.patch \
    && chmod -v +x \
        /etc/cont-init.d/*  \
        /etc/services.d/*/run \
    && apk del build-dependencies \
    && rm -rf /tmp/*

EXPOSE 5050/tcp
VOLUME /config

WORKDIR /config
