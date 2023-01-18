#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $(realpath $0))
WRITING_DIR=${SCRIPT_DIR/\/.writing/}

cd $WRITING_DIR && git add .
git commit -m "Saved at $(date) from $(hostname)"
git push

if [[ -e "$SCRIPT_DIR/local.d/postupload.sh" ]]; then
  $SCRIPT_DIR/local.d/postupload.sh
fi
