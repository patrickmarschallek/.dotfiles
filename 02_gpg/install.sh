#!/usr/bin/env bash

#TODO test if it already exists

exit 0

gpg --full-generate-key
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent

SIGN_KEY=$(gpg-key-list | cut -d' ' -f4 | cut -d'/' -f2)

# TODO add to git config
exit 0
