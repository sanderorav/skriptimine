#!/bin/bash

# See skript teeb backup kaustast test

SRC="./test"
DEST="./backup"
BACKUP_NAME="test.backup.tar.gz"

if [ ! -d "$SRC" ]; then
    echo "Viga: lähtekataloogi $SRC ei eksisteeri!"
    exit 1
fi

if [ ! -d "$DEST" ]; then
    echo "Sihtkataloogi $DEST ei eksisteeri, loon selle..."
    mkdir -p "$DEST"
fi

echo "Teen varukoopia kataloogist '$SRC' ja panen faili '$BACKUP_NAME'."
tar -czf "$DEST/$BACKUP_NAME" -C . "$(basename "$SRC")"

if [ $? -eq 0 ]; then
    echo "Varukoopia edukalt loodud!"
    echo "Kataloog: $SRC"
    echo "Varukoopia asukoht: $DEST/$BACKUP_NAME"
else
    echo "Varundamine ebaõnnestus!"
fi
