# Ansible en un contenedor (partiendo de la imagen UBI8)

El objetivo de este documento es describir cómo usar Docker para:

- crear una imagen con Ansible [^ubi8ansible]
- usar el contenedor con Ansible

## Construcción de la imagen

Clonamos localmente el repositorio y habilitamos la construcción de la imagen usando BuildKit [^buildkit]:

```bash
$ git clone https://github.com/onthedock/docker-ubi8-ansible.git
Cloning into 'docker-ubi8-ansible'...
remote: Enumerating objects: 20, done.
remote: Total 20 (delta 0), reused 0 (delta 0), pack-reused 20
Receiving objects: 100% (20/20), 4.76 KiB | 97.00 KiB/s, done.
Resolving deltas: 100% (8/8), done.

$ cd docker-ubi8-ansible/
$ DOCKER_BUILDKIT=1 docker build .
```

## Error en la construcción de la imagen `docker-ubi8-ansible` para ARM v6 y v7

La construcción de la imagen `docker-ubi8-ansible` basada en `ubi8/ubi:8.5` (de Red Hat) ha fallado porque no existe una imagen base para ARM v6 ni ARM v7 en el Registry de Red Hat.

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

La imagen tampoco existe para ARMv7 y el mensaje de error así lo indica:

```bash
$ docker pull registry.access.redhat.com/ubi8/ubi:8.5
8.5: Pulling from ubi8/ubi
no matching manifest for linux/arm/v7 in the manifest list entries
```

## Referencias

[^ubi8ansible]: Imagen con Ansible [`docker-bui8-ansible` de Jeff Geerling](https://github.com/geerlingguy/docker-ubi8-ansible)

[^buildkit]: Construcción de imágenes con BuildKit [Docker - Build images with BuildKit](https://docs.docker.com/develop/develop-images/build_enhancements/#to-enable-buildkit-builds)
