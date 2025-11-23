#!/usr/bin/env bash
#
# Stop colima profile(s)
#

set -e

PROFILE="${1:-default}"

if [ "$PROFILE" = "all" ]; then
    echo "Stopping all colima profiles..."
    colima list -q | while read -r profile; do
        if [ -n "$profile" ]; then
            echo "Stopping profile: $profile"
            colima stop --profile "$profile" || true
        fi
    done
    echo "✅ All colima profiles stopped"
elif [ "$PROFILE" = "default" ]; then
    echo "Stopping default colima profile..."
    colima stop
    echo "✅ Default colima profile stopped"
else
    echo "Stopping colima profile: $PROFILE"
    colima stop --profile "$PROFILE"
    echo "✅ Colima profile '$PROFILE' stopped"
fi