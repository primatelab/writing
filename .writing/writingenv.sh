#!/usr/bin/env bash

# This script should be sourced

WRITING_DIR=$1
SCRIPT_DIR="$WRITING_DIR/.writing"
lightbrown="\[\033[1;38;5;94m\]"
darkbrown="\[\033[38;5;95m\]"

export MANUSKRIPT_BIN="$SCRIPT_DIR/manuskript/bin/manuskript"

alias upload="$SCRIPT_DIR/upload.sh"
alias download="$SCRIPT_DIR/download.sh"
# alias write="$SCRIPT_DIR/write.sh"
# alias wryte="$SCRIPT_DIR/write.sh"
alias manuskript="$SCRIPT_DIR/write.sh"
alias atmo="$SCRIPT_DIR/atmo.sh"
alias compile="$SCRIPT_DIR/compile.sh"

bookmoji=$(echo -e "\U1F4D6")
PS1=$(echo -e "$bookmoji $lightbrown.writing-\[\033[0m\] $darkbrown")
which guake &>/dev/null && guake -r $bookmoji # Just in case you use guake
history -c
history -r "$SCRIPT_DIR/history"
cd $WRITING_DIR
clear
