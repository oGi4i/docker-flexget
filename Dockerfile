FROM lsiobase/alpine.python3

COPY etc/ /etc

RUN apk --no-cache update && apk add --no-cache \
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
    && pip install --no-cache-dir -U pip flexget kinopoiskpy python-telegram-bot deluge-client \
    && chmod -v +x \
        /etc/cont-init.d/*  \
        /etc/services.d/*/run \
    && apk del build-dependencies \
    && rm -rf /tmp/*

EXPOSE 5050/tcp
VOLUME /config

WORKDIR /config
