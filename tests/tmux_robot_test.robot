*** Settings ***
Documentation     This test attaches to a tmux session, waits for a specified time, executes an echo command, logs the output, and verifies the expected output as an echo.
Library           Process
Library           OperatingSystem
Library           DateTime
Library           Collections

*** Variables ***
${TMUX_SESSION_NAME}    my_tmux_session    # Name of the tmux session
${COMMAND}              echo "Hello from tmux!"    # Command to execute in tmux
${EXPECTED_OUTPUT}      Hello from tmux!    # Expected output after command execution
${WAIT_TIME}            5    # Time in seconds to wait before executing the command
${LOG_FILE}             tests/tmux_output.log    # Path to the log file

*** Test Cases ***
Schedule Command Execution in Tmux
    [Documentation]    Attaches to a tmux session, waits for a fixed time, executes a command, captures the output, and verifies the expected output.
    ...                Steps:
    ...                - Wait for a specified time.
    ...                - Check if the tmux session exists; create it if it doesn't.
    ...                - Send a command to the tmux session.
    ...                - Capture and log the output.
    ...                - Verify that the expected output is present.

    Log    Waiting for ${WAIT_TIME} seconds before executing the command.
    Sleep    ${WAIT_TIME}

    Log    Proceeding to execute the command.

    # Ensure tmux session exists
    ${session_exists}=    Session Exists    ${TMUX_SESSION_NAME}
    IF    not ${session_exists}
        Create Tmux Session    ${TMUX_SESSION_NAME}
    END

    # Send command to tmux session
    Run Process    tmux    send-keys    -t    ${TMUX_SESSION_NAME}    --    ${COMMAND}    Enter

    # Allow time for command to execute
    Sleep    2s

    # Capture tmux pane output
    ${output}=    Run Process    tmux    capture-pane    -t    ${TMUX_SESSION_NAME}    -p    stdout=PIPE
    ${captured_output}=    Set Variable    ${output.stdout.strip()}
    Log    Captured Output:
    Log    ${captured_output}

    # Save output to log file
    Create File    ${LOG_FILE}    ${captured_output}

    # Verify the expected output is present
    Should Contain    ${captured_output}    ${EXPECTED_OUTPUT}    msg=Expected output not found in the captured output.

*** Keywords ***
Session Exists
    [Arguments]    ${session_name}
    [Documentation]    Checks if a tmux session with the given name exists.
    ${result}=    Run Process    tmux    has-session    -t    ${session_name}    stdout=DEVNULL    stderr=DEVNULL
    ${session_exists}=    Evaluate    ${result.rc} == 0
    [Return]    ${session_exists}

Create Tmux Session
    [Arguments]    ${session_name}
    [Documentation]    Creates a new detached tmux session with the given name.
    Run Process    tmux    new-session    -d    -s    ${session_name}
