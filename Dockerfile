ARG SAMBA_VERSION=4.15.7

FROM alpine:3.16

ENV TZ="UTC"

ARG SAMBA_VERSION
ARG SAMBA_RELEASE
RUN apk --update --no-cache add \
    bash \
    coreutils \
    jq \
    samba=${SAMBA_VERSION}-r0 \
    shadow \
    tzdata \
    yq \
  && rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh

EXPOSE 137/udp 138/udp 139 445

VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "smbd", "-F", "--debug-stdout", "--no-process-group" ]

HEALTHCHECK --interval=30s --timeout=10s \
  CMD smbclient -L \\localhost -U % -m SMB3
