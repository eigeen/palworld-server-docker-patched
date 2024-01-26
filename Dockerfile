FROM cm2network/steamcmd:root
LABEL maintainer="thijs@loef.dev"

COPY ./scripts/* /home/steam/server/

# If your region is not in China, you can delete the first command
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    xdg-user-dirs=0.17-2 \
    procps=2:3.3.17-5 \
    wget=1.21-1+deb11u1 \
    bsdiff \
    jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://os3.eigeen.com/public-tmp/palworld-server-patch/rcon-cli_1.6.4_linux_amd64.tar.gz -O - | tar -xz \
    && mv rcon-cli /usr/bin/rcon-cli \
    && chmod +x /home/steam/server/init.sh /home/steam/server/start.sh /home/steam/server/backup.sh /home/steam/server/patch.sh \
    && mv /home/steam/server/backup.sh /usr/local/bin/backup

ENV PORT= \
    PUID=1000 \
    PGID=1000 \
    PLAYERS= \
    MULTITHREADING=false \
    COMMUNITY=false \
    PUBLIC_IP= \
    PUBLIC_PORT= \
    SERVER_PASSWORD= \
    SERVER_NAME= \
    ADMIN_PASSWORD= \
    UPDATE_ON_BOOT=true \
    RCON_ENABLED=true \
    RCON_PORT=25575 \
    QUERY_PORT=27015 \
    TZ=UTC \
    ALWAYS_PATCH=false

WORKDIR /home/steam/server

HEALTHCHECK --start-period=5m \
    CMD pgrep "PalServer-Linux" > /dev/null || exit 1

EXPOSE ${PORT} ${RCON_PORT}
ENTRYPOINT ["/home/steam/server/init.sh"]
