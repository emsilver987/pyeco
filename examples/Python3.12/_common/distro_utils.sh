#!/bin/bash

detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    else
        echo "unknown"
    fi
}

init_distro_context() {
    DISTRO=$(detect_distro)
    echo "Detected distribution: $DISTRO"
    echo "Installing prerequisites..."
}
