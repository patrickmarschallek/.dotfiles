#!/usr/bin/env bash
#
# Java
#
# This installs java versions and registers them to jenv

[[ "$(jenv versions)"  =~ "temurin\|openjdk" ]] && echo "Java is already setup" && exit 0;

# Add Temurin versions from casks (preferred over OpenJDK)
for version in 8 11 17 21; do
  temurin_path="/Library/Java/JavaVirtualMachines/temurin-${version}.jdk/Contents/Home"
  if [ -d "$temurin_path" ]; then
    jenv add "$temurin_path"
    echo "Added Temurin $version to jenv"
  fi
done

# Fallback: Add any OpenJDK versions from Homebrew if they exist
HOMEBREW_DIR="$(brew --prefix)/Cellar"
if [ -d "$HOMEBREW_DIR" ]; then
  dirname $HOMEBREW_DIR/openjdk*/*/bin 2>/dev/null | xargs -I path -n 1 jenv add path 2>/dev/null || true
fi
jenv enable-plugin export

exit 0
