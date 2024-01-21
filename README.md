# lian/docker-uccnc

Docker container for [UCCNC](https://cncdrive.com/UCCNC.html)

The windows GUI of the UCCNC (Stepcraft) CNC Controller Software is run through [Wine](https://en.wikipedia.org/wiki/Wine_(software)) and accessed on a modern web browser (no installation or configuration needed on client side) or via any VNC client.

---

This container is based on [accetto/headless-drawing-g3](https://github.com/accetto/headless-drawing-g3). All the hard work to make GUI (with OpenGL) applications possible inside your browser via docker has been done by them. For advanced usage or modification I suggest you check out their [User Guide](https://accetto.github.io/user-guide-g3/)

---

## Usage

Here is an example of a `docker-compose.yml` file that can be used with
[Docker Compose](https://docs.docker.com/compose/overview/).

Make sure to adjust according to your needs.  Note that only mandatory network
ports are part of the example.

```yaml
version: '3.8'
services:
  uccnc:
    image: "ghcr.io/lian/docker-uccnc:main"
    container_name: uccnc
    shm_size: "256m"
    environment:
      - VNC_PW=uccnc
      - VNC_RESOLUTION=1280x720
      - UCCNC_PROFILE=Stepcraft_M1000T
    ports:
      - "6901:6901"  # just for port refernece, network_mode: host will ignore this
    user: "1000:1000" # your user/group ids
    volumes:
      - "./gcode_files:/gcode_files:ro"
      - "./wine:/wine:rw"
    network_mode: host # to reach UC400ETH at 10.10.10.11
    devices: # for hardware accel opengl
      - /dev/dri:/dev/dri
```

**NOTE**: On first launch, the required fonts, libraries and UCCNC are installed into `/wine`. Further launches skip this step. To start clean again, delete `/wine`.

Launch the UCCNC docker container with the following commands:

```shell
# ensure USER_ID and GROUP_ID from docker-compose.yml are correct
id

# start loxone config container
docker compose up
```

Browse to `http://your-host-ip:6901/vnc.html` to access the UCCNC GUI.

### Data Paths

The following table describes data paths used by the container.  Your host folder `./wine` is mounted into the container to `/wine`

| Container path  | Description |
|-----------------|-------------|
|`/wine`| This is where the application stores its configuration, log and any files needing persistency. |

### Environment Variables

To customize some properties of the container, the following environment
variables can be changed inside `docker-compose.yml`file. Value
of this parameter has the format `<VARIABLE_NAME>=<VALUE>`.

| Variable       | Description                                  | Default |
|----------------|----------------------------------------------|---------|
|`VNC_PW`| Password needed to connect to the application's GUI.  See the [VNC Password](#vnc-password) section for more details. | uccnc |
|`VNC_RESOLUTION`| Display Resolution | 1280x720 |
|`UCCNC_PROFILE`| UCCNC profile to load | Stepcraft_M1000T |

## Accessing the GUI

Assuming that container's ports are mapped to the same host's ports, the
graphical interface of the application can be accessed via:

* A web browser:

```text
http://<HOST IP ADDR>:6901/vnc.html
```

## Getting Help

Having troubles with the container or have questions?  Please [create a new issue](https://github.com/lian/docker-uccnc/issues).
