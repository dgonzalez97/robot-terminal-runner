#!/bin/bash

# Get the directory of the script (tests directory)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Activate the virtual environment
source "$PROJECT_ROOT/venv/bin/activate"

# Run the Robot Framework test with the output directory set to the tests directory
robot --outputdir "$SCRIPT_DIR" "$SCRIPT_DIR/tmux_robot_test.robot"

# Deactivate the virtual environment
deactivate
