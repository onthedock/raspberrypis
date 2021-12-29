# Raspberry Pi 1

## Instalación de Docker

Se ha instalado Docker siguiendo las instrucciones recogidas en [Instalación de Docker CE en Raspbian OS](../docker-on-rpi.md)

## Paquetes adicionales

- Git: `sudo apt install git`

    ```bash
    $ git version
    git version 2.30.2
    ```

## Error en la construcción de la imagen `docker-ubi8-ansible` para ARM v6.1 (RPi 1)

La construcción de la imagen `docker-ubi8-ansible` basada en `ubi8/ubi:8.5` (de Red Hat) ha fallado porque no existe una imagen base para ARM v6.1 en el Registry de Red Hat.

El proceso de creación de la imagen en la RPi1 ha fallado con el siguiente mensaje:

```bash
$ DOCKER_BUILDKIT=1 docker build .
[+] Building 6.3s (3/3) FINISHED                                                                                                            
 => [internal] load build definition from Dockerfile                                0.8s
 => => transferring dockerfile: 1.42kB                                              0.2s
 => [internal] load .dockerignore                                                   0.3s
 => => transferring context: 2B                                                     0.1s
 => ERROR [internal] load metadata for registry.access.redhat.com/ubi8/ubi:8.5      2.9s
------
 > [internal] load metadata for registry.access.redhat.com/ubi8/ubi:8.5:
------
failed to solve with frontend dockerfile.v0: failed to create LLB definition: no match for platform in manifest sha256:228824aa581f3b31bf79411f8448b798291c667a37155bdea61cfa128b2833f2: not found
```

No he sido capaz de interpretar correctamente el mensaje de error en primera instancia.

He validado que la imagen existe y que las instrucciones de descarga son las correctas en el Registry de Red Hat: [Red Hat Universal Base Image 8 (`ubi8/ubi`)](https://catalog.redhat.com/software/containers/ubi8/ubi/5c359854d70cc534b3a3784e?architecture=arm64&container-tabs=gti), así que he intentado obtener la imagen manualmente haciendo un `docker pull`:

```bash
docker pull registry.access.redhat.com/ubi8/ubi:8.5
8.5: Pulling from ubi8/ubi
no matching manifest for linux/arm/v6 in the manifest list entries
```

Aquí el mensaje de error es mucho más explícito y fácil de entender: no existe una imagen para `ARMv6`.

```bash
$ lscpu
Architecture:        armv6l
...
```
