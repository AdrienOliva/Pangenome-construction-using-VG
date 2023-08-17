#!/bin/bash

urls=($(awk -v sample=$1 -F $'\t' '$6 == sample {print $1}' 'igsr_Bedouin in Negev, Israel (HGDP)_undefined.tsv'))

echo $1: ${#urls[*]} urls found

[[ ${#urls[*]} == 0 ]] && exit

mkdir -p $1 || exit

cd $1

for url in ${urls[*]}; do
  echo $url
  wget -q $url
done
