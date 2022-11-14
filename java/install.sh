#!/usr/bin/env bash
#
# Java
#
# This installs java versions and registers them to jenv

dirname /usr/local/Cellar/openjdk*/*/bin | xargs -I path -n 1 jenv add path
