#!/bin/bash

# See skript küsib kasutajalt kausta, mida varundada, ja varundab selle kasutaja poolt sisestaud kausta failina,
# milles on kuupäev.

echo -n "Sisesta varundatava kataloogi nimi: "
read SRC
echo -n "Sisesta sihtkataloogi nimi: "
read DEST
kuupaev=$(date +%Y-%m-%d)
BACKUP_NAME="$SRC.backup.$kuupaev.tar.gz"

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
