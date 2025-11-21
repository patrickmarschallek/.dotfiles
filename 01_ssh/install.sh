#!/usr/bin/env bash

echo "[Install] SSH default key" 

[ -f $HOME/.ssh/id_ed25519 ] && echo "[Installed] SSH key available ($HOME/.ssh/id_ed25519)" && exit 0;

ssh-keygen -t ed25519 -q -f "$HOME/.ssh/id_ed25519" -N "" -C "Patrick Marschallek"
echo "[Installed] SSH key created ($HOME/.ssh/id_ed25519)"

exit 0;
