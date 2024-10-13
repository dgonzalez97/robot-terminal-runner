#!/usr/bin/env python3
"""Module for automating tmux sessions and terminal interactions.

This module provides classes and functions to automate terminal-based
programs using tmux and subprocesses.

Classes:
    TmuxInteractionLib: Manages tmux sessions and processes.

Usage:
    from tmux_interaction_lib import TmuxInteractionLib

    tmux_lib = TmuxInteractionLib()
    tmux_lib.start_program('my_program', params='--option')
"""

import os
import subprocess
import time
import fcntl
import signal
from typing import Optional


class TmuxInteractionLib:
    """Manages tmux sessions and automates terminal interactions.
       This class provides methods to start programs, send commands, read outputs,
    and terminate programs using tmux and subprocesses.
    """

    def __init__(self):
        """Initializes the TmuxInteractionLib."""
        self.proc = None

    def start_program(self, program: str, params: Optional[str] = None, wait_time: int = 2):
        """Starts a program for automation.

        Args:
            program: The program to execute.
            params: Optional parameters for the program.
            wait_time: Time in seconds to wait after starting the program.
        """
        print(f"Starting program '{program}' with parameters '{params}'")
        command = f"{program} {params}" if params else program
        self.proc = subprocess.Popen(
            command,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            shell=True,
            encoding='utf-8',
            preexec_fn=os.setsid  # Start the process in a new session
        )

        # Set the stdout to non-blocking
        flags = fcntl.fcntl(self.proc.stdout, fcntl.F_GETFL)
        fcntl.fcntl(self.proc.stdout, fcntl.F_SETFL, flags | os.O_NONBLOCK)

        print(f"Program '{program}' started successfully.")
        time.sleep(wait_time)

    def send_command(self, message: str):
        """Sends a command to the program's stdin.

        Args:
            message: The command string to send.
        """
        if self.proc and self.proc.stdin:
            print(f"Sending command: {message}")
            self.proc.stdin.write(message + '\n')
            self.proc.stdin.flush()
        else:
            print("Process is not running.")

    def read_output(self) -> str:
        """Reads the output from the program's stdout.

        Returns:
            The output string from the program.
        """
        if self.proc and self.proc.stdout:
            try:
                output = self.proc.stdout.read()
                if output:
                    print(f"Output received: {output}")
                    return output
                else:
                    return ''
            except Exception as e:
                print(f"No output to read: {e}")
                return ''
        else:
            print("Process is not running.")
            return ''

    def close_program(self):
        """Terminates the program."""
        if self.proc:
            print("Terminating the program...")
            os.killpg(os.getpgid(self.proc.pid), signal.SIGTERM)
            self.proc = None
            print("Program terminated.")
        else:
            print("Process is not running.")
