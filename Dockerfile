FROM ghcr.io/linuxserver/baseimage-rdesktop-web:focal

# set version label
ARG BUILD_DATE
ARG VERSION
#ARG CALIBRE_RELEASE
#LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Lockszmith"

ENV \
  CUSTOM_PORT="8080" \
  GUIAUTOSTART="true" \
  HOME="/config"

RUN \
    echo "**** install runtime packages ****" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        git xclip

# Default fonts
ENV NNG_URL="https://github.com/google/fonts/raw/master/ofl/nanumgothic/NanumGothic-Regular.ttf" \
    SCP_URL="https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.tar.gz" 

RUN echo "**** Setup fonts ****" \
    && apt-get install -y --no-install-recommends \
        wget \
    && mkdir -p /usr/share/fonts \
    && wget -qO- "${SCP_URL}" | tar xz -C /usr/share/fonts \
    && wget -q "${NNG_URL}" -P /usr/share/fonts \
    && fc-cache -fv || true

RUN \
  echo "**** cleanup ****" \
  && apt-get remove -y wget \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ /

# Setup Volume mount points
VOLUME /config/data

# RUN \
#   echo "**** initialize static storage ****" \
#   && git clone ....

