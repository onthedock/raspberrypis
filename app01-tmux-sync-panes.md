# Apéndice 01

## Sincronizar los comandos en todos los paneles de TMUX

Cuando se tienen que realizar las mismas acciones en diferentes equipos, podemos usar la opción de *sincronización* de los paneles de TMUX para enviar los mismos comandos a todas las sesiones.

Para habilitar la sincronización en todos los paneles, pulsa `Ctrl+B`, seguido de:

```bash
:setw synchronize-panes on
```

> Para deshabilitarlo, `off`.
