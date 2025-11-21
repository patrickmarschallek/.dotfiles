#!/bin/sh
#

echo "[Install] poetry" 

if command -v poetry &> /dev/null
then
    success "[Installed] poetry already installed" 
    exit 0;
fi

# Poetry
curl -sSL https://install.python-poetry.org | python -
poetry --version
poetry source add --default company https://pypi.company.net/repository/pypi/simple/

# you will be prompted for LDAP password which is securely stored in the System Keyring.
poetry config "http-basic.company" $USER


exit 0
