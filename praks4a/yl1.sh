#!/bin/bash

# See skript küsib kasutajalt nime ja väljastab tema vanuse.

echo -n "Sisesta oma nimi: "
read nimi

echo "Tere tulemast, $nimi!"

echo -n "Sisesta oma sünniaasta: "
read sunniaasta

aasta=$(date +%Y)

vanus=$(( aasta - sunniaasta))

echo "$nimi, sa oled $vanus-aastane."
