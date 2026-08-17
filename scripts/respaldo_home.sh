#!/bin/bash
# Script de respaldo automático en Linux
#
# Este script utiliza el comando tar para crear
# un archivo comprimido (.tar.gz) para respaldar todo el
# contenido del directorio /home.
#
# Desglose del comando utilizado:
#
# tar -> Es una herramienta de empaquetado y respaldo de Linux
# Banderas:
# -c -> Crea un nuevo archivo .tar
# -z -> Comprime usando gzip
# -f -> Indica el nombre del archivo de salida
#
# /var/backups/
# -- Directorio donde se almacenará el respaldo.
#
# respaldo_home_
# Nombre base del archivo de respaldo.
#
# $(date +%F)
# Inserta automáticamente la fecha actual
# en formato AAAA-MM-DD.
#
# Al especificar fecha en el nombre del archivo se evita sobrescribir respaldos anteriores
# y facilita la organización de copias de seguridad.
#
# /home
# Directorio que será respaldado. Generalmente
# contiene archivos y configuraciones de usuarios.

tar -czf /var/backups/respaldo_home_$(date +%F).tar.gz /home
