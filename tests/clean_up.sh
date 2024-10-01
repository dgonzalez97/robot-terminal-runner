#!/bin/bash

# Get the directory of the script (tests directory)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

tmux kill-session -t my_tmux_session
rm -f "$SCRIPT_DIR/output.xml" "$SCRIPT_DIR/log.html" "$SCRIPT_DIR/report.html"
rm -f "$SCRIPT_DIR/tmux_output.log"
