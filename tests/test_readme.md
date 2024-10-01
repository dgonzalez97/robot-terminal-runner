# Tests Directory

This directory contains the Robot Framework test scripts and related files for the `robot-terminal-runner` project.
This folder is to check that your tmux and python enviroment is working correctly.

## Contents

- `tmux_robot_test.robot`: The main Robot Framework test script that automates tmux session interaction.
- `tmux_output.log`: The log file where the output from the tmux session is saved. This file is generated when the test is run.
- `output.xml`, `log.html`, `report.html`: Robot Framework output files generated after running the test.
- `run_test.sh`: Script to run the test.
- `clean_up.sh`: Script to clean up after testing.

## How to Run the Test

You can run the test from the `tests` directory using the provided `run_test.sh` script.

### Steps:

1. **Ensure the Virtual Environment is Set Up:**

   - The virtual environment should be located in the project root directory (`../venv`).
   - If you haven't set it up yet, navigate to the project root and create it:

     ```bash
     python3 -m venv venv
     source venv/bin/activate
     pip install -r requirements.txt
     deactivate
     ```

2. **Run the Test Script:**

   ```bash
   ./run_test.sh
   $ Cleanup the test folder after using
   ./clean_up.sh
