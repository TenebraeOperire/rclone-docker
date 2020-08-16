FROM alpine:latest
MAINTAINER TenebraeOperire

# global environment settings
ENV PLATFORM_ARCH="amd64"

# s6 environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

# install packages
RUN apk update && apk add --no-cache ca-certificates nano && \
    apk add --no-cache --virtual=build-dependencies wget curl unzip

# rclone and s6 overlay
RUN curl -o /tmp/s6-overlay.tar.gz -L \
	"https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-${PLATFORM_ARCH}.tar.gz" && \
    tar xfz /tmp/s6-overlay.tar.gz -C / && \
    curl -o /tmp/rclone.zip -L \
    "https://downloads.rclone.org/rclone-current-linux-${PLATFORM_ARCH}.zip" && \
    unzip /tmp/rclone.zip -d /tmp && \
    mv /tmp/rclone-*-linux-${PLATFORM_ARCH}/rclone /usr/bin && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community shadow && \
    unset RCLONE_VERSION && \
    apk del --purge build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

# create abc user
RUN groupmod -g 1000 users && \
    useradd -u 911 -U -d /config -s /bin/false abc && \
    usermod -G users abc

# create some files / folders
RUN mkdir -p /config /data && \
    touch /var/lock/rclone.lock

# add local files
COPY root/ /

VOLUME ["/config"]

ENTRYPOINT ["/init"]
