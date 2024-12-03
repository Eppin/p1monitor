# Build container
FROM debian:bookworm AS builder
WORKDIR /app

ENV TZ="Europe/Amsterdam"

RUN apt update && \
    apt upgrade -y && \
    apt-get install -y \
    build-essential pkg-config libcairo2-dev \
    libpython3-dev python3-venv python3-cryptography && \
    apt-get clean

# Apply patches
COPY python/scripts ./scripts
COPY python/patches ./patches
RUN patch -u ./scripts/crypto3.py -i ./patches/crypto3.patch && \
    patch -u ./scripts/p1mon.sh -i ./patches/p1mon.patch && \
    patch -u ./scripts/P1Watchdog.py -i ./patches/P1Watchdog.patch && \
    patch -u ./scripts/sqldb.py -i ./patches/sqldb.patch && \
    patch -u ./scripts/system_info_lib.py -i ./patches/system_info_lib.patch && \
    rm -rf ./patches

# Python - create virtual env, install packages and copy scripts
RUN python3 -m venv /p1mon/p1monenv
COPY python/requirements.txt /p1mon/p1monenv
WORKDIR /p1mon/p1monenv
RUN /bin/bash -c "source ./bin/activate && pip3 install -r requirements.txt && pip3 uninstall -y pycrypto && pip3 install pycryptodome"

# Publish container
FROM nginx:1.25.4-bookworm AS publish

ENV TZ="Europe/Amsterdam"

RUN apt update && \
    apt upgrade -y && \
    apt-get install -y \
    sudo iputils-ping iproute2 logrotate \
    # Python3
    python3-venv \
    # PHP 8.2
    php-fpm php-sqlite3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# NGINX
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/proxy_params /etc/nginx/proxy_params
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

RUN adduser --disabled-password --gecos '' p1mon && \
    adduser p1mon sudo && \
    usermod -aG p1mon www-data && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY --chown=p1mon:p1mon www /p1mon/www

# Copy Python virtual env from builder container
COPY --from=builder /p1mon/p1monenv /p1mon/p1monenv

# Copy scripts
WORKDIR /p1mon
COPY --chown=p1mon:p1mon --from=builder app/scripts ./scripts
RUN mkdir -p data export mnt/ramdisk mnt/usb && chown -R p1mon:p1mon ./data ./export ./mnt

WORKDIR /

# Copy stubs
COPY stub/iw /sbin/iw
COPY stub/systemctl /sbin/systemctl
RUN chmod +x /sbin/iw && chmod +x /sbin/systemctl

COPY stub/nmbd /etc/init.d/nmbd
COPY stub/smbd /etc/init.d/smbd
RUN chmod +x /etc/init.d/nmbd && chmod +x /etc/init.d/smbd

# Define entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

HEALTHCHECK CMD curl -f http://127.0.0.1/healthchecks/ || exit 1
USER p1mon

ENTRYPOINT [ "./entrypoint.sh" ]
