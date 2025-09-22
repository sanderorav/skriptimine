#!/bin/bash
echo -n "Sisesta varundatava kataloogi nimi (nt /path/to/test): "
read -r SRC
echo -n "Sisesta sihtkataloogi nimi (nt ./backup): "
read -r DEST

SRC=$(eval echo "$SRC")
DEST=$(eval echo "$DEST")

kuupaev=$(date +%Y-%m-%d)
src_dirname=$(dirname "$SRC")
src_basename=$(basename "$SRC")
BACKUP_NAME="${src_basename}.backup.${kuupaev}.tar.gz"

[ -d "$SRC" ]  || { echo "Viga: lähtekataloogi '$SRC' ei ole!"; exit 1; }
[ -d "$DEST" ] || { echo "Loon sihtkataloogi '$DEST'..."; mkdir -p "$DEST" || exit 1; }

# Kui fail on juba olemas, küsi kasutajalt
if [ -f "$DEST/$BACKUP_NAME" ]; then
    echo "Varukoopia fail '$BACKUP_NAME' on juba olemas."
    echo -n "Kas soovid teha uue varukoopia (jah/ei)? "
    read -r answer
    if [[ "$answer" =~ ^[Jj]ah$ || "$answer" =~ ^[Yy]es$ ]]; then
        n=1
        NEW_BACKUP_NAME="${src_basename}.backup.${kuupaev}-${n}.tar.gz"
        while [ -f "$DEST/$NEW_BACKUP_NAME" ]; do
            ((n++))
            NEW_BACKUP_NAME="${src_basename}.backup.${kuupaev}-${n}.tar.gz"
        done
        BACKUP_NAME="$NEW_BACKUP_NAME"
        echo "Uus varukoopia fail: $BACKUP_NAME"
    else
        echo "Varundamine katkestatud."
        exit 0
    fi
fi

echo "Teen varukoopia kataloogist: $SRC"
echo "Varukoopia fail: $BACKUP_NAME"
echo "Sihtkataloog: $DEST"

# Loo arhiiv (ära ignoreeri vigu!)
tar -czf "$DEST/$BACKUP_NAME" -C "$src_dirname" "$src_basename" 2>/dev/null
status=$?

if [ $status -eq 0 ]; then
    echo "Varukoopia loodud: $DEST/$BACKUP_NAME"
    exit 0
else
    echo "Varundamine ebaõnnestus! (tar väljus koodiga $status)"
    exit $status
fi
