FROM lsiobase/alpine.python3

COPY etc/ /etc

COPY patches/ /patches
COPY scripts/ /usr/local/bin

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
        python3-dev \
    && pip install --no-cache-dir -U pip flexget kinopoiskpy python-telegram-bot deluge-client \
    && cd /usr/lib/python3.6/site-packages/flexget/components/tmdb
    && patch -i /patches/tmdb_lookup.py.patch \
    && chmod -v +x \
        /etc/cont-init.d/*  \
        /etc/services.d/*/run \
    && apk del build-dependencies \
    && rm -rf /tmp/*

EXPOSE 5050/tcp
VOLUME /config

WORKDIR /config
