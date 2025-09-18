#!/bin/bash

# See skript küsib kasutajalt kausta, mida varundada, ja varundab selle
# kasutaja poolt sisestatud sihtkataloogi failina, milles on kuupäev.

echo -n "Sisesta varundatava kataloogi nimi (nt /path/to/test): "
read -r SRC
echo -n "Sisesta sihtkataloogi nimi (nt ./backup): "
read -r DEST

# Normaliseeri ja võta ainult kausta nimi varukoopia failinime jaoks
kuupaev=$(date +%Y-%m-%d)
src_dirname=$(dirname "$SRC")
src_basename=$(basename "$SRC")
BACKUP_NAME="${src_basename}.backup.${kuupaev}.tar.gz"

# Kontrollid
if [ ! -d "$SRC" ]; then
    echo "Viga: lähtekataloogi '$SRC' ei eksisteeri!"
    exit 1
fi

if [ ! -d "$DEST" ]; then
    echo "Sihtkataloogi '$DEST' ei eksisteeri, loon selle..."
    mkdir -p "$DEST" || { echo "Viga: ei saanud luua kataloogi '$DEST'"; exit 1; }
fi

# Selgitav väljund
echo "Teen varukoopia kataloogist: $SRC"
echo "Varukoopia fail: $BACKUP_NAME"
echo "Sihtkataloog: $DEST"

# Paki nii, et arhiivis oleks ka kausta nimi (mitte ainult sisu)
# NB! -C vahetab kataloogi lähtekausta VANEMA peale
tar -czf "$DEST/$BACKUP_NAME" -C "$src_dirname" "$src_basename"

if [ $? -eq 0 ]; then
    echo "Varukoopia edukalt loodud: $DEST/$BACKUP_NAME"
else
    echo "Varundamine ebaõnnestus!"
    exit 1
fi
