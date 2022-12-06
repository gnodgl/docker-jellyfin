FROM ghcr.io/linuxserver/baseimage-ubuntu:focal

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
  echo "deb [arch=$( dpkg --print-architecture )] https://repo.jellyfin.org/$( awk -F'=' '/^ID=/{ print $NF }' /etc/os-release ) $( awk -F'=' '/^VERSION_CODENAME=/{ print $NF }' /etc/os-release ) main"   > /etc/apt/sources.list.d/jellyfin.list && \
  if [ -z ${JELLYFIN_RELEASE+x} ]; then \
    JELLYFIN="jellyfin-server"; \
    JELLYFIN_WEB="jellyfin-web"; \
  else \
    JELLYFIN="jellyfin-server=${JELLYFIN_RELEASE}-1"; \
    JELLYFIN_WEB="jellyfin-web=${JELLYFIN_RELEASE}-1"; \
  fi && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    at \
    ${JELLYFIN} \
    jellyfin-ffmpeg5 \
    ${JELLYFIN_WEB} \
    libfontconfig1 \
    libfreetype6 \
    fonts-noto-cjk-extra \
    libssl1.1 \
    mesa-va-drivers && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# add local files
COPY root/ / 

# ports and volumes
EXPOSE 8096 8920
VOLUME /config
