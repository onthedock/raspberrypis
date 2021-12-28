# Raspberry Pi

- [x] Sistema operativo: Raspbian Lite (Raspberry Pi OS Lite) - Actualizado a Diciembre 2021
- [x] Usuario: `pi`
- [x] Password: `${cotxeBlau}`
- [x] Acceso vía clave SSH

Se ha generado una clave SSH en el Latitude D630 `rpi_key`

```bash
ssh-keygen -t rsa -b 4096
```

Se ha copiado la clave pública a cada una de las RPi (2, 31 y 32)

```bash
ssh-copy-id -i ~/.ssh/rpi_key pi@192.168.1.136
```

Se ha generado el fichero `~/.ssh/config` para simplificar la conexión a las RPis:

> (Se ha actualizado el *snippet* para reflejar las IPs finales de las RPis) 

```ini
Host rpi31
  Hostname 192.168.1.31
  User pi
  IdentityFile ~/.ssh/rpi_key
  IdentitiesOnly yes
Host rpi32
  Hostname 192.168.1.31
  User pi
  IdentityFile ~/.ssh/rpi_key
  IdentitiesOnly yes
Host rpi2
  Hostname 192.168.1.20
  User pi
  IdentityFile ~/.ssh/rpi_key
  IdentitiesOnly yes
Host rpi1
  Hostname 192.168.1.10
  User pi
  IdentityFile ~/.ssh/rpi_key
  IdentitiesOnly yes
```

- [ ] Cambio de configuración de red - IP estática

Modificamos el fichero `/etc/dhcpcd.conf` añadiendo al final

```ini
interface eth0
static ip_address=192.168.1.20/24
static routers=192.168.1.1
static domain_names=192.168.1.1
```

## Raspberry Pi 1

La Raspberry Pi 1 tiene un único *core* ARM1176 (ARM v6.1) y 512 MB de RAM.

```ini
Architecture:        armv6l
Byte Order:          Little Endian
CPU(s):              1
On-line CPU(s) list: 0
Thread(s) per core:  1
Core(s) per socket:  1
Socket(s):           1
Vendor ID:           ARM
Model:               7
Model name:          ARM1176
Stepping:            r0p7
CPU max MHz:         700.0000
CPU min MHz:         700.0000
BogoMIPS:            697.95
Flags:               half thumb fastmult vfp edsp java tls
```

### Instalación de Docker CE

Seguimos las intrucciones de la [documentación oficial de Docker](https://docs.docker.com/engine/install/debian/#install-using-the-convenience-script) para instalar Docker CE en Raspbian (la recomendación es usar el *script* de conveniencia proporcionado:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
chmod +x get-docker.sh
sudo ./get-docker.sh
```

Tras instalar Docker CE, añadimos al usuario al grupo de Docker [Post-installation steps for Linux](https://docs.docker.com/engine/install/linux-postinstall/):

```bash
sudo usermod -aG docker $USER
```

La versión instalada es:

```bash
$ docker --version
Docker version 20.10.12, build e91ed57
```

## Raspberry Pi 2

TO BE DONE

## Raspberry Pi 3

TO BE DONE

## Apéndice

## Sincronizar los comandos en todos los paneles de TMUX

Cuando se tienen que realizar las mismas acciones en diferentes equipos, podemos usar la opción de *sincronización* de los paneles de TMUX para enviar los mismos comandos a todas las sesiones.

Para habilitar la sincronización en todos los paneles, pulsa `Ctrl+B`, seguido de:

```bash
:setw synchronize-panes on
```

> Para deshabilitarlo, `off`.

