#!/bin/bash

setup_python312_venv() {
    local requirements_file="${1:-requirements.txt}"
    shift || true

    python3.12 -m venv venv
    # shellcheck source=/dev/null
    source venv/bin/activate

    if [ "${SETUP_PYTHON312_UPGRADE_PIP:-0}" = "1" ]; then
        pip install --upgrade pip
    fi

    pip install "$@" -r "$requirements_file"
}
