FROM debian:bookworm-slim as builder

ENV VAULT_VERSION 1.11.3
ENV KUMA_VERSION 1.8.0
ENV ARCH arm64

WORKDIR /tmp/

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O -L https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${ARCH}.zip
RUN unzip vault_${VAULT_VERSION}_linux_${ARCH}.zip

RUN curl -O -L https://download.konghq.com/mesh-alpine/kuma-${KUMA_VERSION}-debian-${ARCH}.tar.gz
RUN tar --extract --strip-components=2 --file=kuma-${KUMA_VERSION}-debian-${ARCH}.tar.gz kuma-${KUMA_VERSION}/bin/kuma-dp

FROM debian:bookworm-slim

COPY --from=builder /tmp/vault /usr/local/bin
COPY --from=builder /tmp/kuma-dp /usr/local/bin