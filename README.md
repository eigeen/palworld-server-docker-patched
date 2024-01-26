# Palworld Dedicated Server Docker

![Release](https://img.shields.io/github/v/release/eigeen/palworld-server-docker)
![Docker Pulls](https://img.shields.io/docker/pulls/eigeen/palworld-server-docker)
![Docker Stars](https://img.shields.io/docker/stars/eigeen/palworld-server-docker)
![Image Size](https://img.shields.io/docker/image-size/eigeen/palworld-server-docker/latest)

[View on Docker Hub](https://hub.docker.com/r/eigeen/palworld-server-docker)

This repo is modified based on https://github.com/thijsvanloef/palworld-server-docker, applied https://github.com/VeroFess/PalWorld-Server-Unoffical-Fix unofficial patch, try to fix the official server memory leaks and high load.

该仓库基于 https://github.com/thijsvanloef/palworld-server-docker 修改，应用了 https://github.com/VeroFess/PalWorld-Server-Unoffical-Fix 非官方补丁，尝试修正官方服务端的内存泄漏和高负载问题。

### Docker Compose

```yml
services:
   palworld:
      image: eigeen/palworld-server-docker:latest
      restart: unless-stopped
      container_name: palworld-server
      ports:
        - 8211:8211/udp
        - 27015:27015/udp
      environment:
         - PUID=1000
         - PGID=1000
         - PORT=8211 # Optional but recommended
         - PLAYERS=16 # Optional but recommended
         - SERVER_PASSWORD="worldofpals" # Optional but recommended
         - MULTITHREADING=true
         - RCON_ENABLED=true
         - RCON_PORT=25575
         - TZ=UTC
         - ADMIN_PASSWORD="adminPasswordHere"
         - COMMUNITY=false  # Enable this if you want your server to show up in the community servers tab, USE WITH SERVER_PASSWORD!
         - SERVER_NAME="World of Pals"
         - UPDATE_ON_BOOT=true
         - ALWAYS_PATCH=false
      volumes:
         - ./palworld:/palworld/
```

New env: `ALWAYS_PATCH`, set to true to check the hash and try to patch every time you start up the server.

`UPDATE_ON_BOOT` is recommended to set to true when you start or download game files for the first time.

Please refer to the original repo for more settings.