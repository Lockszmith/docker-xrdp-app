A fork of the docker-calibre from the [LinuxServer.io](https://linuxserver.io) team modified to host spacemacs develop branch.

# [Lockszmith/docker-spacemacs](https://github.com/Lockszmith/docker-spacemacs)

[![GitHub Stars](https://img.shields.io/github/stars/Lockszmith/docker-spacemacs.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/Lockszmith/docker-spacemacs)
[![GitHub Release](https://img.shields.io/github/release/Lockszmith/docker-spacemacs.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/Lockszmith/docker-spacemacs/releases)
[![GitHub Package Repository](https://img.shields.io/static/v1.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=linuxserver.io&message=GitHub%20Package&logo=github)](https://github.com/Lockszmith/docker-spacemacs/packages)
[![Docker Pulls](https://img.shields.io/docker/pulls/Lockszmith/spacemacs.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/Lockszmith/spacemacs)
[![Docker Stars](https://img.shields.io/docker/stars/Lockszmith/spacemacs.svg?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=stars&logo=docker)](https://hub.docker.com/r/Lockszmith/spacemacs)

[spacemacs](https://www.spacemacs.org/) Spacemacs is a new way of experiencing Emacs -- it's a sophisticated and polished set-up, focused on ergonomics, mnemonics and consistency.

Just clone and launch it, then press the space bar to explore the interactive list of carefully-chosen key bindings. You can also press the home buffer's [?] button for some great first key bindings to try.

Spacemacs can be used naturally by both Emacs and Vim users -- you can even mix the two editing styles. Being able to quickly switch between input styles, makes Spacemacs a great tool for pair-programming.

Spacemacs is currently in beta, and any contributions are very welcome.

[![spacemacs_python](doc/img/spacemacs-python.png)](https://www.spacemacs.org/)

## Supported Architectures

We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list) and our announcement [here](https://blog.linuxserver.io/2019/02/21/the-lsio-pipeline-project/).

Simply pulling `ghcr.io/Lockszmith/spacemacs` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | latest |

## Application Setup

This image sets up the spacemacs desktop app and makes its interface available via Guacamole server in the browser. The interface is available at `http://your-ip:8080`.

By default, there is no password set for the main gui. Optional environment variable `PASSWORD` will allow setting a password for the user `abc`.

You can access advanced features of the Guacamole remote desktop using `ctrl`+`alt`+`shift` enabling you to use remote copy/paste and different languages.

## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose ([recommended](https://docs.linuxserver.io/general/docker-compose))

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.1"
services:
  spacemacs:
    image: ghcr.io/Lockszmith/spacemacs
    container_name: spacemacs
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    # - PASSWORD= #optional
    # - CLI_ARGS= #optional
    volumes:
      - /path/to/data:/config
    ports:
      - 8080:8080
    restart: unless-stopped
```

### docker cli

```bash
docker run -d \
  --name=spacemacs \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
# -e PASSWORD= `#optional` \
# -e CLI_ARGS= `#optional` \
  -p 8080:8080 \
  -v /path/to/data:/config \
  --restart unless-stopped \
  ghcr.io/Lockszmith/spacemacs
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 8080` | Spacemacs desktop gui. |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-e PASSWORD=` | Optionally set a password for the gui. |
| `-e CLI_ARGS=` | Optionally pass cli start arguments to emacs. |
| `-v /config` | Where spacemacs should store its configuration. |

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

## Support Info

* Shell access whilst the container is running: `docker exec -it spacemacs /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f spacemacs`
* container version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' spacemacs`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' ghcr.io/Lockszmith/spacemacs`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Compose

* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull spacemacs`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d spacemacs`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Run

* Update the image: `docker pull ghcr.io/Lockszmith/spacemacs`
* Stop the running container: `docker stop spacemacs`
* Delete the container: `docker rm spacemacs`
* Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (only use if you don't remember the original parameters)

* Pull the latest image at its tag and replace it with the same env variables in one run:

  ```bash
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once spacemacs
  ```

* You can also remove the old dangling images: `docker image prune`

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using [Docker Compose](https://docs.linuxserver.io/general/docker-compose).

### Image Update Notifications - Diun (Docker Image Update Notifier)

* We recommend [Diun](https://crazymax.dev/diun/) for update notifications. Other tools that automatically update containers unattended are not recommended or supported.

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```bash
git clone https://github.com/Lockszmith/docker-spacemacs.git
cd docker-spacemacs
docker build \
  --no-cache \
  --pull \
  -t ghcr.io/Lockszmith/spacemacs:latest .
```

The ARM variants can be built on x86_64 hardware using `multiarch/qemu-user-static`

```bash
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

Once registered you can define the dockerfile to use with `-f Dockerfile.aarch64`.

## Versions

* **21.07.01:** - First version
