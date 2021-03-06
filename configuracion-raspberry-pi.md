# Raspberry Pi

- [x] Sistema operativo: Raspbian Lite (Raspberry Pi OS Lite) - Actualizado a Diciembre 2021
- [x] Usuario: `pi`
- [x] Password: `${cotxeBlau}`
- [x] Acceso vía clave SSH

Se ha generado una clave SSH en el Latitude D630 `rpi_key`

```bash
ssh-keygen -t rsa -b 4096
```

Se ha copiado la clave pública a cada una de las RPi (1, 2, 31 y 32)

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
  Hostname 192.168.1.32
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

- [x] Cambio de configuración de red - IP estática

Modificamos el fichero `/etc/dhcpcd.conf` añadiendo al final

```ini
interface eth0
static ip_address=192.168.1.20/24
static routers=192.168.1.1
static domain_names=192.168.1.1
```

Reiniciamos la RPi para aplicar los cambios.

## Raspberry Pi 1

La Raspberry Pi 1 tiene un único *core* ARM1176 (ARM v6.1) y 512 MB de RAM.

```yaml
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

## Raspberry Pi 2

La RPi 2 tiene 4 *cores* Cortex-A7  (ARM v7.1) y 1 GB de RAM.

```yaml
Architecture:        armv7l
Byte Order:          Little Endian
CPU(s):              4
On-line CPU(s) list: 0-3
Thread(s) per core:  1
Core(s) per socket:  4
Socket(s):           1
Vendor ID:           ARM
Model:               5
Model name:          Cortex-A7
Stepping:            r0p5
CPU max MHz:         900.0000
CPU min MHz:         600.0000
BogoMIPS:            38.40
Flags:               half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
```

## Raspberry Pi 3

La RPi 3 tiene 4 cores Cortex-A53 (ARM v7.1), 1 GB de RAM y conectividad WiFi.

```yaml
Architecture:        armv7l
Byte Order:          Little Endian
CPU(s):              4
On-line CPU(s) list: 0-3
Thread(s) per core:  1
Core(s) per socket:  4
Socket(s):           1
Vendor ID:           ARM
Model:               4
Model name:          Cortex-A53
Stepping:            r0p4
CPU max MHz:         1200.0000
CPU min MHz:         600.0000
BogoMIPS:            38.40
Flags:               half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm crc32
```
