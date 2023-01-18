#!/usr/bin/env bash

SCRIPT_DIR=$(dirname $(realpath $0))
WRITING_DIR=${SCRIPT_DIR/\/.writing/}

[[ ! -e $SCRIPT_DIR/initted ]] && $WRITING_DIR/init.sh
[[ ! -e $WRITING_DIR/backgrounds ]] && ln -s "$SCRIPT_DIR/backgrounds" "$WRITING_DIR/backgrounds"

cd $WRITING_DIR && git pull
