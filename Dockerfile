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
  if [ -z ${JELLYFIN_RELEASE+x} ]; then \
    curl -s https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | apt-key add - && \
    echo 'deb [arch=amd64] https://repo.jellyfin.org/ubuntu focal main' > /etc/apt/sources.list.d/jellyfin.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      at \
      jellyfin-server \
      jellyfin-ffmpeg5 \
      jellyfin-web \
      libfontconfig1 \
      libfreetype6 \
      fonts-noto-cjk-extra \
      libssl1.1 \
      mesa-va-drivers ; \
  else \
    curl -o jellyfin_server.deb https://repo.jellyfin.org/releases/server/ubuntu/versions/stable/server/${JELLYFIN_RELEASE}/jellyfin-server_${JELLYFIN_RELEASE}-1_amd64.deb &&\
    curl -o jellyfin_web.deb https://repo.jellyfin.org/releases/server/ubuntu/versions/stable/web/${JELLYFIN_RELEASE}/jellyfin-web_${JELLYFIN_RELEASE}-1_all.deb &&\
    curl -o jellyfin-ffmpeg5.deb https://repo.jellyfin.org/releases/server/ubuntu/versions/jellyfin-ffmpeg/${FFMPEG5_RELEASE}/jellyfin-ffmpeg5_${FFMPEG5_RELEASE}-focal_amd64.deb &&\
    dpkg -i jellyfin_*.deb jellyfin-ffmpeg5.deb && \
    apt-get install -y --no-install-recommends \
      at \
      libfontconfig1 \
      libfreetype6 \
      fonts-noto-cjk-extra \
      libssl1.1 \
      mesa-va-drivers && \
    apt-get -f install ; \
  fi && \
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
