FROM ghcr.io/linuxserver/baseimage-ubuntu:noble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG JELLYFIN_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    gnupg && \
  echo "**** install jellyfin *****" && \
     curl -s https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | apt-key add - && \
     echo 'deb [arch=amd64] https://repo.jellyfin.org/ubuntu noble main' > /etc/apt/sources.list.d/jellyfin.list && \
  if [ -z ${JELLYFIN_RELEASE+x} ]; then \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      at \
      jellyfin-server \
      jellyfin-ffmpeg6 \
      jellyfin-web \
      libfontconfig1 \
      libfreetype6 \
      libjemalloc2 \
      fonts-noto-cjk-extra \
      xmlstarlet \
      mesa-va-drivers ; \
  else \
    curl -o jellyfin_server.deb -L https://repo.jellyfin.org/files/server/ubuntu/stable/v${JELLYFIN_RELEASE}/amd64/jellyfin-server_${JELLYFIN_RELEASE}+ubu2404_amd64.deb &&\
    curl -o jellyfin_web.deb -L https://repo.jellyfin.org/files/server/ubuntu/stable/v${JELLYFIN_RELEASE}/amd64/jellyfin-web_${JELLYFIN_RELEASE}+ubu2404_all.deb &&\
    apt-get update && \
    apt-get install -y --no-install-recommends \
      at \
      jellyfin-ffmpeg6\
      libfontconfig1 \
      libfreetype6 \
      libjemalloc2 \
      fonts-noto-cjk-extra \
      xmlstarlet \
      mesa-va-drivers && \
    dpkg -i jellyfin_*.deb && \
    apt-get -f install ; \
  fi && \
  echo "**** cleanup ****" && \
  rm -rf \
    *.deb \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ / 

# ports and volumes
EXPOSE 8096 8920
VOLUME /config
