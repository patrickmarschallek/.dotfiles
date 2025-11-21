#!/usr/bin/env bash
#
# install nvm to provide different node environemnts

nvm_is_installed() {
    return [ -d "$HOME/.nvm" ]
}

nvm_is_not_loaded() {
    return ! command -v "nvm" &> /dev/null 
}

load_nvm() {
  info "loading NVM to proceed"
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
}

[ nvm_is_installed ] && success "NVM is already installed" || \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash 
  
nvm_is_not_loaded && load_nvm || \
    success "NVM is loaded and can be used"

command -v "node" &> /dev/null && success "NodeJS is already installed" || \
    nvm install --lts node

command -v "npm" &> /dev/null && success "NPM is already installed" || \
    fail "Node is not properly installed NPM is not available."

command -v "yarn" &> /dev/null && success "Yarn is already installed" || \
    npm install -g yarn
