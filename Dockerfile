FROM alpine:latest as builder
LABEL maintainer "Cheewai Lai <cheewai.lai@gmail.com>"
ARG BORG_VERSION=1.1.10
RUN apk upgrade --no-cache \
    && apk add --no-cache \
    alpine-sdk \
    python3-dev \
    openssl-dev \
    lz4-dev \
    acl-dev \
    linux-headers \
    fuse-dev \
    attr-dev \
    && pip3 install --upgrade pip \
    && pip3 install --upgrade borgbackup==${BORG_VERSION} \
    && pip3 install llfuse

FROM alpine:latest
LABEL maintainer "Cheewai Lai <cheewai.lai@gmail.com>"
ARG GOSU_VERSION=1.11
RUN apk upgrade --no-cache \
 && apk add --no-cache \
    tzdata \
    sshfs \
    python3 \
    openssl \
    ca-certificates \
    lz4-libs \
    libacl \
    bash \
    curl \
 && rm -rf /var/cache/apk/* \
 && curl -o gosu -fsSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64" \
 && mv gosu /usr/bin/gosu \
 && chmod +x /usr/bin/gosu

COPY docker-entrypoint.sh /docker-entrypoint.sh

COPY --from=builder /usr/lib/python3.6/site-packages /usr/lib/python3.6/
COPY --from=builder /usr/bin/borg /usr/bin/
COPY --from=builder /usr/bin/borgfs /usr/bin/

ENTRYPOINT ["/docker-entrypoint.sh"]
