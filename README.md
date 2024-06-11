This is a Fork of https://github.com/linuxserver/docker-duckdns which i modified to add Dual-Stack support and ipv6 only support, without the need of a dns query.

This is just meant to be a personal fork for my servers, but if you need the modification, i gladly share it. Otherwise head over to https://github.com/linuxserver/docker-duckdns

## Application Setup

- Go to the [duckdns website](https://duckdns.org/), register your subdomain(s) and retrieve your token
- Create a container with your subdomain(s) and token
- It will update your IP with the DuckDNS service every 5 minutes (with a random jitter)

## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose (recommended, [click here for more info](https://docs.linuxserver.io/general/docker-compose))

```yaml
---
version: "2.1"
services:
  duckdns:
    image: mainfrezzer/duckdns:latest
    container_name: duckdns
    environment:
      - PUID=1000 #optional
      - PGID=1000 #optional
      - TZ=Etc/UTC #optional
      - SUBDOMAINS=subdomain1,subdomain2
      - TOKEN=token
      - LOG_FILE=false #optional
      - IPV6=dual #choose between false, dual or only
    volumes:
      - /path/to/appdata/config:/config #optional
    restart: unless-stopped
```

### docker cli ([click here for more info](https://docs.docker.com/engine/reference/commandline/cli/))

```bash
docker run -d \
  --name=duckdns \
  -e PUID=1000 `#optional` \
  -e PGID=1000 `#optional` \
  -e TZ=Etc/UTC `#optional` \
  -e SUBDOMAINS=subdomain1,subdomain2 \
  -e TOKEN=token \
  -e LOG_FILE=false `#optional` \
  -e IPV6=dual `#choose between false, dual or only` \
  -v /path/to/appdata/config:/config `#optional` \
  --restart unless-stopped \
  mainfrezzer/duckdns:latest

```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Etc/UTC` | specify a timezone to use, see this [list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List). |
| `-e SUBDOMAINS=subdomain1,subdomain2` | multiple subdomains allowed, comma separated, no spaces |
| `-e TOKEN=token` | DuckDNS token |
| `-e LOG_FILE=false` | Set to `true` to log to file (also need to map /config). |
| `-e IPV6=dual` | Set to `false` to only update the ipv4, `dual` for both and `only` for ipv6 only. |
| `-v /config` | Used in conjunction with logging to file. |

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```bash
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

Will set the environment variable `PASSWORD` based on the contents of the `/run/secrets/mysecretpassword` file.

## Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask) before asking for support.

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```bash
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

You only need to set the PUID and PGID variables if you are mounting the /config folder
