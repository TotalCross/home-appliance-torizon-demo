# Build instructions

Allow experimental build (cross-compile stuff)
```bash
host$ export DOCKER_CLI_EXPERIMENTAL=enabled
```

Run to make avaiable
```bash
host$ docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
```

Build your container
```bash
host$ docker build . -t totalcross/home-appliance-demo --no-cache
```
(Optional) Create a tag with you don't want use latest tag:

```bash
host$ docker tag <newest id> totalcross/home-appliance-demo:<tag>
```

Push your changes (latest):
```bash
host$ docker push totalcross/home-appliance-demo:<tag>
```

Copy `docker-compose.armxx.yml` to your Torizon system:
```bash
host$ scp docker-compose.armxx.yml torizon@192.168.0.xxx:~/docker-compose.yaml
```

In Torizon, you just need to run:
```bash
torizon$ docker-compose up -d
```

To finish the application, run:
```bash
torizon$ docker-compose down
```