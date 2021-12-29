# Instalación de Docker CE en Raspbian OS

Seguimos las intrucciones de la [documentación oficial de Docker](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script) para instalar Docker CE en Raspbian (la recomendación es usar el *script* de conveniencia proporcionado):

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
sudo ./get-docker.sh
```

Tras instalar Docker CE, añadimos al usuario `pi` al grupo de Docker [Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/):

```bash
sudo usermod -aG docker $USER
```

Comprobamos la versión de Docker instalada:

```bash
$ docker --version
Docker version 20.10.12, build e91ed57

$ docker version
Client: Docker Engine - Community
 Version:           20.10.12
 API version:       1.41
 Go version:        go1.16.12
 Git commit:        e91ed57
 Built:             Mon Dec 13 11:45:28 2021
 OS/Arch:           linux/arm
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.12
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.12
  Git commit:       459d0df
  Built:            Mon Dec 13 11:43:45 2021
  OS/Arch:          linux/arm
  Experimental:     false
 containerd:
  Version:          1.4.12
  GitCommit:        7b11cfaabd73bb80907dd23182b9347b4245eb5d
 runc:
  Version:          1.0.2
  GitCommit:        v1.0.2-0-g52b36a2
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```
