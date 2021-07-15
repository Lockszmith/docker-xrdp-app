#FROM ghcr.io/linuxserver/baseimage-rdesktop-web:focal
# focal (focal-0.1.1-ls17 currently has a bug with the apt signatures)
FROM ghcr.io/linuxserver/baseimage-rdesktop-web:focal-0.1.1-ls16

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
    echo "# 0. Update package database and install wget"              \
    && apt-get update                                                 \
    && apt-get install -y --no-install-recommends                     \
        git wget

RUN \
    echo "# 1. Install signal's official public software signing key" \
    && wget -O- https://updates.signal.org/desktop/apt/keys.asc |     \
       gpg --dearmor > signal-desktop-keyring.gpg                     \
    && cat signal-desktop-keyring.gpg |                               \
       tee -a /usr/share/keyrings/signal-desktop-keyring.gpg          \
       > /dev/null                                                    \
    && echo "# 2. Add our repository to your list of repositories"    \
    && echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
      tee -a /etc/apt/sources.list.d/signal-xenial.list               \
    && echo "# 3. Update your package database and install signal"    \
    && apt-get update                                                 \
    && apt-get install -y --no-install-recommends                     \
        git xclip notification-daemon xauth signal-desktop

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
  echo "**** cleanup ****"               \
  && apt-get remove -y wget              \
  && apt-get clean                       \
      /tmp/*                             \
      /var/lib/apt/lists/*               \
      /var/tmp/*

# add local files
COPY root/ /

# Setup Volume mount points
VOLUME /config/data

# RUN \
#   echo "**** initialize static storage ****" \
#   && git clone ....

