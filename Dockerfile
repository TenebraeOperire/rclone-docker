FROM alpine:latest
MAINTAINER TenebraeOperire

# global environment settings
ENV PLATFORM_ARCH="amd64"

# s6 environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

# override default config location
ENV RCLONE_CONFIG=/config/rclone.conf

# install packages
RUN apk update --no-cache && apk add --no-cache ca-certificates nano curl

# rclone and s6 overlay etc
RUN apk add --no-cache --virtual=build-dependencies wget unzip && \
    apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community shadow && \
    curl -o /tmp/s6-overlay.tar.gz -L \
	"https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-${PLATFORM_ARCH}.tar.gz" && \
    tar xfz /tmp/s6-overlay.tar.gz -C / && \
    curl -o /tmp/rclone.zip -L \
    "https://downloads.rclone.org/rclone-current-linux-${PLATFORM_ARCH}.zip" && \
    unzip /tmp/rclone.zip -d /tmp && \
    mv /tmp/rclone-*-linux-${PLATFORM_ARCH}/rclone /usr/bin && \
    unset RCLONE_VERSION && \
    apk del --purge build-dependencies && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

# create abc user
RUN groupmod -g 1000 users && \
    useradd -u 911 -U -d /config -s /bin/false abc && \
    usermod -G users abc && \
    mkdir -p /config /data && \
    touch /var/lock/rclone.lock

# add local files
COPY root/ /

VOLUME ["/config"]

ENTRYPOINT ["/init"]
