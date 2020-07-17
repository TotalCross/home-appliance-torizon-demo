# TotalCross #

[TotalCross](https://www.toradex.com/pt-br/support/partner-network/services/200011/totalcross) is an Open Source SDK providing a Fast and Easy to Use way to build beautiful User Interfaces for embedded, IoT, mobile and desktop.

TotalCross version 6 added support for Linux ARM and support for Torizon.

## TotalCross Demo for Torizon ##

TotalCross has created a Demo container for Torizon and uploaded it to Docker Hub. On this container there are some of TotalCross' features:
- Graphic API;
- Screen transitions;
- Animations;
- Basic components(e.g. Edits, Labels...).

## Supported Modules ##

The following Computer on Modules are supported:

- Apalis iMX8QM
- Colibri iMX6ULL
- Colibri iMX6DL
- Colibri iMX7D

## Supported Displays ##

- [Capacitive Touch Display 7" Parallel](https://developer.toradex.com/products/capacitive-touch-display-7inch-parallel)
- [Resistive Touch Display 7" Parallel](https://developer.toradex.com/products/parallel-resistive-touch-display)
- HDMI/DVI Screens

# How to Get Started #

This section provides information on how to use the TotalCross Demo container.

## Running TotalCross Demo container ##

You just need to add `docker-compose.yaml` to your Torizon `root` folder. See what model to use below:

[TABS]
[TAB-TITLE] 32-bits modules [/TAB-TITLE]
[TAB-CONTENT]

For 32-bits modules like Colibri i.MX6ULL or DL, the code below should be placed on the `docker-compose.yaml` file.

```yaml
version: "2.4"
services:
  weston:
    image: torizon/arm32v7-debian-weston:latest
    network_mode: host
    volumes:
    - type: bind
      source: /tmp
      target: /tmp
    - type: bind
      source: /dev
      target: /dev
    - type: bind
      source: /run/udev
      target: /run/udev
    cap_add:
    - CAP_SYS_TTY_CONFIG
     # Add device access rights through cgroup...
    device_cgroup_rules:
       # ... for tty0
       - 'c 4:0 rmw'
       # ... for tty7
       - 'c 4:7 rmw'
       # ... for /dev/input devices
       - 'c 13:* rmw'
       # ... for /dev/dri devices
       - 'c 226:* rmw'
  totalcross:
    image: totalcross/home-appliance-demo:1.0.1
    command: bash -c "./start.sh"
    network_mode: host
    volumes:
      - type: bind
        source: /tmp
        target: /tmp
      - type: bind
        source: /var/run/dbus
        target: /var/run/dbus
      - type: bind
        source: /dev/dri
        target: /dev/dri
    depends_on:
      - weston
    shm_size: '512mb'
    device_cgroup_rules:
      - 'c 226:* rmw'
```

[/TAB-CONTENT]
[TAB-TITLE] 64-bits modules [/TAB-TITLE]
[TAB-CONTENT]

For 64-bits modules like Apalis i.MX8M, the code below should be placed on the `docker-compose.yaml` file.

{.note} Remember to uncomment line 7 to accept Vivante Graphics Drivers EULA

```yaml
version: "2.4"
services:
  weston:
    environment:
    # please uncomment the following line to accept the
    # EULA required to run imx8 vivante graphic drivers
    # - ACCEPT_FSL_EULA=1
      - XDG_RUNTIME_DIR=/run/display
    container_name: weston
    image: torizon/arm64v8-debian-weston-vivante:latest
    volumes:
      - type: bind
        source: /tmp
        target: /tmp
      - type: bind
        source: /dev
        target: /dev
      - type: bind
        source: /run/udev
        target: /run/udev
    cap_add:
      - CAP_SYS_TTY_CONFIG
    # Add device access rights through cgroup...
    device_cgroup_rules:
      # ... for tty0
      - "c 4:0 rmw"
      # ... for tty7
      - "c 4:7 rmw"
      # ... for /dev/input devices
      - "c 13:* rmw"
      - "c 199:* rmw"
      # ... for /dev/dri devices
      - "c 226:* rmw"
  totalcross:
    image: totalcross/home-appliance-demo:1.0.1
    command: bash -c "./start.sh"
    network_mode: host
    volumes:
      - type: bind
        source: /tmp
        target: /tmp
      - type: bind
        source: /var/run/dbus
        target: /var/run/dbus
      - type: bind
        source: /dev/dri
        target: /dev/dri
    depends_on:
      - weston
    shm_size: '512mb'
    device_cgroup_rules:
      - 'c 226:* rmw'
```

[/TAB-CONTENT]
[/TABS]

Finally, run compositor inside Torizon environment and see  the results!

```bash
$ docker-compose up -d
```

(Optional) end the application:
```bash
$ docker-compose down
```

## Next Steps ##

See the container [repository](https://github.com/TotalCross/home-appliance-torizon-demo). For more information on TotalCross:
- [See the documentation](https://learn.totalcross.com/documentation/get-started);
- [See the open source code](https://github.com/TotalCross/totalcross).

# Release Notes

This solution was made avaiable since version 6.0.2, but the recommended version is the newest one.

- [TotalCross Changelog](https://learn.totalcross.com/totalcross-change-log)

# Licensing Information #

TotalCross is licensed under GNU LGLPL-2.1-only.

## See also

- [Webinar: Creating GUI for Toradex modules with TotalCross Open Source SDK](https://www.toradex.com/pt-br/webinars/gui-for-toradex-modules-totalcross-open-source-sdk)
