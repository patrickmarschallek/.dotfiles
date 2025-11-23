#!/bin/sh
#

echo "[Configure] pip" 

if command -v "pip3" &> /dev/null 
then
    fail "pip3 is not installed" 
    exit 0;
fi

# pip setup
pip3 install -U pip keyring

[ ! -d ' $HOME/.pip' ] fail "[Failed] to configure pip due to missing directory: $HOME/.pip" && exit 1;

cat << 'EOF' > $HOME/.pip/pip.conf
[global]
index-url = https://${USER}@pypi.company.net/repository/pypi/simple
trusted-host = localhost pypi.company.net
EOF

success "[Configured] pip $(pip --version)" 

exit 0
