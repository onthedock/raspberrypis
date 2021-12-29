# Ansible en un contenedor

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

## Referencias

[^ubi8ansible]: Imagen con Ansible [`docker-bui8-ansible` de Jeff Geerling](https://github.com/geerlingguy/docker-ubi8-ansible)

[^buildkit]: Construcción de imágenes con BuildKit [Docker - Build images with BuildKit](https://docs.docker.com/develop/develop-images/build_enhancements/#to-enable-buildkit-builds)