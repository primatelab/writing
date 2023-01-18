#!/bin/bash

SCRIPT_DIR=$(dirname $(realpath $0))
BG_DIR="${SCRIPT_DIR/\/.writing/}/backgrounds"

while [[ $chosen != 'chosen' ]]; do
  clear
  echo -e "============================================\033[1;38;5;94m"
  ls $BG_DIR
  echo -e "\033[38;5;95m============================================"
  cd $BG_DIR
  read -e -p " Choose a background:$(echo -e "\033[1;38;5;94m") " bg


  if [[ -e "$bg" && "$bg" =~ \.(jpg|jpeg)$ ]]; then
    echo
    $SCRIPT_DIR/viu "$bg" -w64
    echo
    read -sn1 -p "This one? [Y|n]" yn
    if [[ ! ${yn^^} == 'N' ]]; then
      rm -f $SCRIPT_DIR/backgrounds/atmo.jpg
      ln -s "$(realpath "$bg")" $SCRIPT_DIR/backgrounds/atmo.jpg
      chosen='chosen'
    fi
    echo
  else
    echo Not a .jpg
  fi
done
