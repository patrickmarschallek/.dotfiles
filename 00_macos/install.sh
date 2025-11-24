#!/usr/bin/env bash
#
# macOS Software Updates
#
# This checks for and optionally installs macOS software updates

set -e

# Only run on macOS
if test ! "$(uname)" = "Darwin"; then
    exit 0
fi

source "$(dirname "$0")/../helper.sh"

info "Checking for macOS software updates"

# Check if updates are available without requiring sudo
if softwareupdate -l 2>/dev/null | grep -q "recommended\|restart"; then
    info "macOS software updates are available"
    info "Updates can be installed with: sudo softwareupdate -i -a"
    info "Some updates may require a system restart"

    # Note: We don't automatically install updates to avoid unexpected sudo prompts
    # Users can run the update command manually when they're ready
else
    success "macOS software is up to date"
fi

exit 0
