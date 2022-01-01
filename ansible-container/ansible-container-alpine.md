# Ansible en un contenedor (partiendo de la imagen Alpine)

El objetivo de este documento es describir cómo usar Docker para:

- crear una imagen con Ansible [^alpineansible]
- usar el contenedor con Ansible

## Construcción de la imagen

Clonamos localmente el repositorio y habilitamos la construcción de la imagen usando BuildKit [^buildkit]:

```bash
$ git clone https://github.com/onthedock/docker-ansible-alpine.git
Cloning into 'docker-ansible-alpine'...
remote: Enumerating objects: 455, done.
remote: Counting objects: 100% (20/20), done.
remote: Compressing objects: 100% (14/14), done.
remote: Total 455 (delta 9), reused 16 (delta 6), pack-reused 435
Receiving objects: 100% (455/455), 80.18 KiB | 707.00 KiB/s, done.
Resolving deltas: 100% (254/254), done.
$ cd docker-ansible-alpine/
```

Tras clonar el repositorio, modifico el fichero `hooks/build` para adaptarlo a mi entorno y lo lanzo (desde la carpeta raíz del repositorio, donde se encuentra el `Dockerfile`):

```bash
$ ./hooks/build
[+] Building 2016.5s (11/11) FINISHED                                                                                                       
 => [internal] load build definition from Dockerfile                                                        0.1s
 => => transferring dockerfile: 1.90kB                                                                      0.0s
 => [internal] load .dockerignore                                                                           0.0s
 => => transferring context: 2B                                                                             0.0s
 => [internal] load metadata for docker.io/library/alpine:3.15.0                                            7.6s
 => [1/6] FROM docker.io/library/alpine:3.15.                             0@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300                                  3.0s
 => => resolve docker.io/library/alpine:3.15.                             0@sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300                                  0.1s
 => => sha256:5480d2ca1740c20ce17652e01ed2265cdc914458acd41256a2b1ccff28f2762c 2.43MB / 2.43MB              1.3s
 => => sha256:21a3deaa0d32a8057914f36584b5288d2e5ecc984380bc0118285c70fa8c9300 1.64kB / 1.64kB              0.0s
 => => sha256:8483ecd016885d8dba70426fda133c30466f661bb041490d525658f1aac73822 528B / 528B                  0.0s
 => => sha256:78571b13081b3f0e2737073f044b9b37aae887b4196f673fdd0dc03fa4a1b7bc 1.48kB / 1.48kB              0.0s
 => => extracting sha256:5480d2ca1740c20ce17652e01ed2265cdc914458acd41256a2b1ccff28f2762c                   1.1s
 => [internal] load build context                                                                           0.1s
 => => transferring context: 1.57kB                                                                         0.0s
 => [2/6] RUN apk --update --no-cache add ca-certificates git openssh-client openssl python3               26.0s
 => [3/6] RUN apk --update add --virtual .build-deps python3-dev libffi-dev openssl-dev bu               1853.9s
 => [4/6] RUN mkdir -p /etc/ansible  && echo 'localhost' > /etc/ansible/hosts  && echo -e """\nHost *\n    StrictHostKeyChecking no\n 4.4s 
 => [5/6] COPY entrypoint /usr/local/bin/                                                                   0.3s 
 => [6/6] WORKDIR /ansible                                                                                  0.4s 
 => exporting to image                                                                                    119.6s 
 => => exporting layers                                                                                   119.5s 
 => => writing image sha256:6ce94f6f26c89928d4ec70efdbe33a4e7dbb9028986ea4fc64457c4a48e9f395                0.0s 
 => => naming to docker.io/xaviaznar/ansible-alpine:2.10.7
```

Verificamos que se ha creado la imagen en la *cache* local:

```bash
$ docker images
REPOSITORY                 TAG       IMAGE ID       CREATED          SIZE
xaviaznar/ansible-alpine   2.10.7    6ce94f6f26c8   12 minutes ago   415MB
```

## Validación

Validamos que la imagen permite ejecutar Ansible; para ello, creamos un fichero de inventario `inventory` y un *playbook*:

```bash
.
├── ansible-playbooks
│   ├── inventory
│   ├── update.yaml
│   └──run-playbook.sh
└── docker-ansible-alpine
    ├── Dockerfile
    ├── entrypoint
    ├── hooks
    │   ├── build
    │   ├── build_latest
    │   └── post_push
    ├── LICENSE
    └── README.md
```

- `ansible-plabooks/` contiene el fichero de inventario y el playbook de actualización. También contiene el *script* para lanzar los *playbooks* de manera más cómoda
- `docker-ansible-alpine` contiene los ficheros para crear la imagen con Ansible

### Inventario

```yaml
all:
  hosts:
    192.168.1.20:
    192.168.1.31:
    192.168.1.32:
  children:
    k3s:
      hosts:
        192.168.1.31:
        192.168.1.32:
    rpi2:
      hosts:
        192.168.1.20:
```

### *Script*

```bash
#!/usr/bin/env bash
playbook=$1
inventoryFile=$2
docker run -it --rm \
  -v $HOME/ansible-playbooks:/ansible \
  -v $HOME/.ssh:/ssh \
  -e ANSIBLE_HOST_KEY_CHECKING=no \
  -e ANSIBLE_PRIVATE_KEY_FILE=/ssh/rpi_key \
  xaviaznar/ansible-alpine:2.10.7 \
  ansible-playbook -i $inventoryFile $playbook
```

### *Playbook* de actualización

```yaml
---
- name: Update RPis
  hosts: all
  remote_user: pi
  become: yes

  tasks:
  - name: Update, upgrade and autoremove
    ansible.builtin.apt:
      update_cache=yes
      upgrade=yes
      autoremove=yes
```

Finalmente, lanzamos el contenedor para ejecutar el *playbook*:

> Los *warnings* son resultado de [Ansible - Interpreter Discovery](https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html)

```bash
$ ./run-playbook.sh update.yaml inventory

PLAY [Update RPis] *************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************
[WARNING]: Platform linux on host 192.168.1.32 is using the discovered Python interpreter at /usr/bin/python, but future installation of
another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information.
ok: [192.168.1.32]
[WARNING]: Platform linux on host 192.168.1.31 is using the discovered Python interpreter at /usr/bin/python, but future installation of
another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information.
ok: [192.168.1.31]
[WARNING]: Platform linux on host 192.168.1.20 is using the discovered Python interpreter at /usr/bin/python, but future installation of
another Python interpreter could change the meaning of that path. See
https://docs.ansible.com/ansible/2.10/reference_appendices/interpreter_discovery.html for more information.
ok: [192.168.1.20]

TASK [Update, upgrade and autoremove] ******************************************************************************************************
changed: [192.168.1.32]
changed: [192.168.1.31]
changed: [192.168.1.20]

PLAY RECAP *********************************************************************************************************************************
192.168.1.20               : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
192.168.1.31               : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
192.168.1.32               : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

---

[^alpineansible] [Github - `pad92/docker-ansible-alpine`](https://github.com/pad92/docker-ansible-alpine)

[^buildkit]: Construcción de imágenes con BuildKit [Docker - Build images with BuildKit](https://docs.docker.com/develop/develop-images/build_enhancements/#to-enable-buildkit-builds)

[^virtual]: [StackOverflow - What is .build-deps for apk add --virtual command?](https://stackoverflow.com/questions/46221063/what-is-build-deps-for-apk-add-virtual-command)

[^mitogen]: [Mitogen for Ansible](https://mitogen.networkgenomics.com/ansible_detailed.html)
