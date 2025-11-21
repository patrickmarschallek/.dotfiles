#!/usr/bin/env bash

echo "[Install] Hyper terminal plugins"

installed_plugins=($(hyper ls))
SAVEIFS=$IFS   # Save current IFS (Internal Field Separator)
IFS=$'\n'      # Change IFS to newline char
intsalled_plugins=($installed_plugins) # split the `names` string into an array by the same name
IFS=$SAVEIFS   # Restore original IFS

plugins=(hyper-font-ligatures hyper-one-dark hyperline)
uninstall=(hyper-monokai-glow)

rc_file=${HOME}/.npmrc
rc_file_backup="${rc_file}.bck"

# the custom npmrc file needs to be deactivated due to some errors 
# in hyper for plugin installation via private repos
[[ -f ${rc_file} ]] && mv $rc_file $rc_file_backup


for plugin in "${plugins[@]}"
do 
  if [[ ${installed_plugins[*]} =~ ${plugin} ]]
  then
    echo "[Installed] '${plugin}'"
  else
    echo "[Installing] ${plugin}"
    hyper install $plugin
  fi

done

for plugin in "${uninstall[@]}"
do 
  if [[ ${installed_plugins[*]} =~ ${plugin} ]]
  then
    echo "[Uninstalling] '${plugin}'"
    hyper uninstall $plugin
  fi

done

[[ -f ${rc_file_backup} ]] && mv $rc_file_backup $rc_file

exit 0
