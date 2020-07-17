# Requirements

You only needs [Docker](https://docs.docker.com/get-docker/) on your host PC, a [Torizon compatible board](https://developer.toradex.com/software/torizon) and a network connection (SSH)!

# Instructions

Hello! See how to start your project with TotalCross and Torizon. But first, allow experimental build (cross-compile stuff)
```bash
host$ export DOCKER_CLI_EXPERIMENTAL=enabled
```

Enable multiarch build
```bash
host$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```
## Build & publish

> Remember to change the name of the container if necessary (arg after `-t`) and to login in your DockerHub account with `docker login`

To build your container
```bash
host$ docker build . -t totalcross/home-appliance-demo
```
(Optional) Create a tag with you don't want use *latest* tag:

```bash
host$ docker tag <newest id> totalcross/home-appliance-demo:<tag>
```

Push your changes (maybe *latest*):
```bash
host$ docker push totalcross/home-appliance-demo:<tag>
```

## Run

>(Optional) To force the updating of your app on the device you should pull the changes on Docker
>```bash
>torizon$ docker pull totalcross/home-appliance-demo:<tag>
>```
>

You have some options to run your app

### Command line

Depending on your device you must choose your option (ex. "Apalis iMX8QM is 64-bits, that's why I must choose the second option")

1. If device is 32-bits:

    ```bash
    torizon$ docker run -d --rm --name=weston --net=host --cap-add CAP_SYS_TTY_CONFIG \
             -v /dev:/dev -v /tmp:/tmp -v /run/udev/:/run/udev/ \
             --device-cgroup-rule='c 4:* rmw'  --device-cgroup-rule='c 13:* rmw' --device-cgroup-rule='c 226:* rmw' \
              torizon/arm32v7-debian-weston:buster --developer weston-launch --tty=/dev/tty7 --user=torizon -- --use-pixman

    torizon$ docker run --rm -it --name=totalcross \
            -v /tmp:/tmp \
            -v /dev/dri:/dev/dri --device-cgroup-rule='c 226:* rmw' \
            totalcross/home-appliance-demo:latest
    ```

2. If device is 64-bits:
    ```bash
    torizon$ docker run -e ACCEPT_FSL_EULA=1 -d --rm --name=weston --net=host --cap-add CAP_SYS_TTY_CONFIG \
             -v /dev:/dev -v /tmp:/tmp -v /run/udev/:/run/udev/ \
             --device-cgroup-rule='c 4:* rmw'  --device-cgroup-rule='c 13:* rmw' --device-cgroup-rule='c 199:* rmw' --device-cgroup-rule='c 226:* rmw' \
              torizon/arm64v8-debian-weston-vivante:buster --developer weston-launch --tty=/dev/tty7 --user=torizon

    torizon$ docker run --rm -it --name=totalcross \
        -v /tmp:/tmp \
        -v /dev/dri:/dev/dri --device-cgroup-rule='c 226:* rmw' \
        totalcross/home-appliance-demo:latest
    ```
### Docker compose

Copy `docker-compose.armxx.yml` to your Torizon system:
```bash
host$ scp docker-compose.armxx.yml torizon@192.168.0.xxx:~/docker-compose.yml
```

In Torizon, you just need to run:
```bash
torizon$ docker-compose up -d
```

To finish the application, run
```bash
torizon$ docker-compose down
```
> If you have troubles with *docker-compose* please read **Command line** option
