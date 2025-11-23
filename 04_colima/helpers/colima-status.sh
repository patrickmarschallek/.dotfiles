#!/usr/bin/env bash
#
# Show comprehensive colima and Docker status
#

set -e

echo "=== Colima Status ==="
if command -v colima >/dev/null 2>&1; then
    colima version
    echo ""

    if colima list >/dev/null 2>&1; then
        echo "Colima profiles:"
        colima list
    else
        echo "No colima profiles found"
    fi
else
    echo "❌ Colima not installed"
fi

echo ""
echo "=== Docker Status ==="
if command -v docker >/dev/null 2>&1; then
    echo "Docker version: $(docker --version)"
    echo "Current context: $(docker context show 2>/dev/null || echo 'unknown')"

    if docker info >/dev/null 2>&1; then
        echo "✅ Docker daemon is running"
        echo "Docker info:"
        docker info --format "{{.Name}}: {{.ServerVersion}}"
        docker info --format "CPUs: {{.NCPU}}, Memory: {{.MemTotal}}"
    else
        echo "❌ Docker daemon is not running"
    fi

    echo ""
    echo "Available contexts:"
    docker context ls --format "table {{.Name}}\t{{.Current}}\t{{.Description}}"
else
    echo "❌ Docker not installed"
fi

echo ""
echo "=== Docker Socket Configuration ==="
if [ -L /var/run/docker.sock ]; then
    LINK_TARGET=$(readlink /var/run/docker.sock)
    echo "✅ /var/run/docker.sock -> $LINK_TARGET"
elif [ -S /var/run/docker.sock ]; then
    echo "ℹ️  /var/run/docker.sock (regular socket)"
else
    echo "❌ /var/run/docker.sock not found"
fi

echo ""
echo "=== Environment Variables ==="
echo "DOCKER_HOST: ${DOCKER_HOST:-not set}"
echo "TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE: ${TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE:-not set}"
echo "TESTCONTAINERS_HOST_OVERRIDE: ${TESTCONTAINERS_HOST_OVERRIDE:-not set}"
echo "TESTCONTAINERS_RYUK_DISABLED: ${TESTCONTAINERS_RYUK_DISABLED:-not set}"

echo ""
echo "=== System Resources ==="
if command -v colima >/dev/null 2>&1 && colima status >/dev/null 2>&1; then
    echo "Colima VM resources:"
    colima status 2>/dev/null | grep -E "(cpu|memory|disk)" || echo "Resource info not available"

    # Show colima address for Testcontainers
    if command -v jq >/dev/null 2>&1; then
        COLIMA_ADDRESS=$(colima ls -j 2>/dev/null | jq -r '.address' 2>/dev/null || echo "unknown")
        echo "Colima address: $COLIMA_ADDRESS"
    fi
fi