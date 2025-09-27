FROM postgres:18.0

LABEL maintainer="mail@jstet.net"
LABEL description="PostgreSQL 18 with WAL-G backup support"
LABEL version="1.0.0"

ARG TARGETARCH
ARG TARGETOS
ARG TARGETPLATFORM

ENV WALG_VERSION=v3.0.7 \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      wget=1.21.6-1ubuntu1.2 \
      curl=7.68.0-1ubuntu2.18 \
      daemontools=0.76-37build1 \
      cron=3.0pl1-136.1ubuntu1 \
      gettext-base=0.21-0ubuntu1.1 \
      ca-certificates=20210119~20.04.2 && \
    rm -rf /var/lib/apt/lists/*

# download and install WAL-G with progress bar
RUN set -eux; \
    case "${TARGETARCH}" in \
      amd64) WALG_ARCH="amd64";   WALG_FILE="wal-g-pg-ubuntu-20.04-amd64.tar.gz"; ;; \
      arm64) WALG_ARCH="aarch64"; WALG_FILE="wal-g-pg-ubuntu-20.04-aarch64.tar.gz"; ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    echo "Downloading WAL-G ${WALG_VERSION} for ${TARGETARCH}..."; \
    wget --progress=dot:giga \
      "https://github.com/wal-g/wal-g/releases/download/${WALG_VERSION}/${WALG_FILE}" && \
    tar -zxvf "${WALG_FILE}" && \
    mv "wal-g-pg-ubuntu-20.04-${WALG_ARCH}" /usr/local/bin/wal-g && \
    chmod +x /usr/local/bin/wal-g && \
    rm "${WALG_FILE}"; \
    echo "WAL-G installed: $(wal-g --version)"

# prepare directories and permissions
RUN mkdir -p /etc/wal-g/env /var/log/wal-g /scripts /var/spool/cron/crontabs && \
    chown -R postgres:postgres /etc/wal-g /var/log/wal-g /scripts

# copy helper scripts
COPY scripts/ /scripts/
RUN chmod +x /scripts/*.sh

COPY scripts/entrypoint.sh /usr/local/bin/docker-entrypoint-walg.sh
RUN chmod +x /usr/local/bin/docker-entrypoint-walg.sh

EXPOSE 5432

ENTRYPOINT ["/usr/local/bin/docker-entrypoint-walg.sh"]
CMD ["postgres"]
