# Raspberry Pi 1

> La RPi 1 dejó de funcionar el 31/12/2021 (el led rojo y el verde se iluminan, pero no muestra señal de vídeo).

## Instalación de Docker

Se ha instalado Docker siguiendo las instrucciones recogidas en [Instalación de Docker CE en Raspbian OS](../docker-on-rpi.md)

## Paquetes adicionales

- Git: `sudo apt install git`

    ```bash
    $ git version
    git version 2.30.2
    ```

## Cockpit

La instalación de este *panel de control* para Linux se realiza mediante:

```bash
sudo apt install cockpit
```

El acceso a la consola de CockPit en la RPi1 se realiza a través del puerto 9090: `https://rpi1:9090/`.

> Las siguientes configuraciones deberían automatizarse mediante Ansible

## Deshabilitar IPv6

Crea el fichero `/etc/sysctl.d/disable-ipv6.conf` con la línea `net.ipv6.conf.all.disable_ipv6 = 1`:

```bash
$ cd /etc/sysctl.d/
$ sudo su
# echo "net.ipv6.conf.all.disable_ipv6 = 1" > disable-ipv6.conf
# exit
$
```

A continuación, crea el fichero `/etc/modprobe.d/blacklist-ipv6.conf` con la línea `blacklist ipv6`:

```bash
$ cd /etc/modprobe.d
# echo "blacklist ipv6" > blacklist-ipv6.conf
# exit
$
```

## Deshabilitar WiFi, BlueTooth y audio

La Raspberry Pi 1 no tiene WiFi ni Bluetooth, pero los deshabilitamos de todos modos.

Para ello, es necesario añadir las líneas al final del fichero `/boot/config.txt`:

- `dtoverlay=disable-bt`
- `dtoverlay=disable-wifi`

> Hacemos una copia de seguridad del fichero primero.

```bash
$ sudo cp /boot/config.txt /boot/config.txt.bkp-20211230
$ echo "dtoverlay=disable-bt" | sudo tee -a /boot/config.txt
dtoverlay=disable-bt
$ echo "dtoverlay=disable-wifi" | sudo tee -a /boot/config.txt
dtoverlay=disable-wifi
```

Validamos que se han realizado los cambios en el fichero:

```bash
$ tail -3 /boot/config.txt
gpu_mem=16
dtoverlay=disable-bt
dtoverlay=disable-wifi
```

Deshabilitamos el servicio de WiFi:

```bash
$ sudo systemctl mask wpa_supplicant.service
Created symlink /etc/systemd/system/wpa_supplicant.service → /dev/null.
```

También deshabilitamos el modem:

```bash
$ sudo systemctl disable hciuart
Removed /etc/systemd/system/multi-user.target.wants/hciuart.service.
```

También deshabilito el audio (y lo valido):

```bash
$ sudo sed -i '/dtparam=audio/c dtparam=audio=off' /boot/config.txt
$ cat /boot/config.txt | grep -i audio=
dtparam=audio=off
```

Despues de realizar estos cambios y reiniciar la RPi1:

```bash
$ free -h
               total        used        free      shared  buff/cache   available
Mem:           477Mi        82Mi        86Mi       0.0Ki       307Mi       340Mi
Swap:           99Mi       0.0Ki        99Mi

$ free -h
               total        used        free      shared  buff/cache   available
Mem:           477Mi        69Mi       220Mi       0.0Ki       187Mi       358Mi
Swap:           99Mi          0B        99Mi
```

Referencia: [opensource.com - Set up a minimal server on a Raspberry Pi](https://opensource.com/article/21/1/minimal-server-raspberry-pi)
