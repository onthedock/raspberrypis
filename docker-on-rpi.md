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
```
