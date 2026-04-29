#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../_common/distro_utils.sh"

init_distro_context

set -e

# -------------------------------
# Install system dependencies
# -------------------------------
case $DISTRO in
    "fedora"|"rhel"|"centos"|"rocky"|"almalinux")
        if command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y python3.12 python3.12-devel python3-pip 
        else
            sudo yum install -y python3.12 python3.12-devel python3-pip 
        fi
        ;;
    "ubuntu"|"debian")
        export DEBIAN_FRONTEND=noninteractive 
        sudo apt update
        sudo apt install -y python3.12 python3.12-dev python3-pip python3.12-venv 
        ;;
    "sles")
        sudo zypper refresh
        sudo zypper install -y python312 python312-pip
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac

# -------------------------------
# Create and activate virtual env
# -------------------------------
python3.12 -m venv .venv
source .venv/bin/activate

# -------------------------------
# Upgrade pip and install packages
# -------------------------------
pip install --upgrade pip
pip install --prefer-binary --extra-index-url=https://wheels.developerfirst.ibm.com/ppc64le/linux -r requirements.txt

# -------------------------------
# Run the environment test
# -------------------------------
echo "Running environment test..."
python3 xgboost_example.py

echo "\n ==== Running tests ==== \n"

python3 sub-test1.py
python3 sub-test2.py
python3 sub-test3.py
python3 sub-test4.py
