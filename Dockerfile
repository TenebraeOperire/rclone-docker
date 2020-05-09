FROM alpine:latest
MAINTAINER TenebraeOperire

# global environment settings
ENV PLATFORM_ARCH="amd64"
ARG RCLONE_VERSION="current"

# s6 environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENV S6_KEEP_ENV=1

# install packages
RUN apk update
RUN apk add --no-cache ca-certificates

# install build packages
RUN apk add --no-cache --virtual=build-dependencies wget curl unzip nano

RUN OVERLAY_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]')

RUN curl -o /tmp/s6-overlay.tar.gz -L \
	"https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${PLATFORM_ARCH}.tar.gz"
RUN tar xfz /tmp/s6-overlay.tar.gz -C /

RUN cd tmp
RUN wget -q https://downloads.rclone.org/v${RCLONE_VERSION}/rclone-v${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip
RUN unzip /tmp/rclone-v${RCLONE_VERSION}-linux-${PLATFORM_ARCH}.zip
RUN mv /tmp/rclone-*-linux-${PLATFORM_ARCH}/rclone /usr/bin

RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community shadow

# cleanup
RUN unset RCLONE_VERSION
RUN apk del --purge build-dependencies
RUN rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

# create abc user
RUN groupmod -g 1000 users
RUN useradd -u 911 -U -d /config -s /bin/false abc
RUN usermod -G users abc

# create some files / folders
RUN mkdir -p /config /data
RUN touch /var/lock/rclone.lock

# add local files
COPY root/ /

VOLUME ["/config"]

ENTRYPOINT ["/init"]
