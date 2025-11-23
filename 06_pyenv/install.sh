#!/bin/sh
#

info "[Install] python" 

if command -v "pyenv" &> /dev/null
then
    success "[Installed] pyenv already installed $(pyenv --version)" 
fi
if command -v "python3" &> /dev/null
then
    info "$(which python3)"
    success "[Installed] python already installed $(python3 --version)"
fi

if [[ "3.10.8" == "$(pyenv version-name)" ]]
then
    success "[Installed] python $(python3 --version)"
    exit 0
fi

# list installed versions
info $(pyenv versions)

pyenv install 3.10
pyenv global 3.10
success "[Installed] python $(python3 --version)"

exit 0
