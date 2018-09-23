#!/usr/bin/bash

# Relocate to the script's directory so that the test and solution directories
# can be found regardless of where the script was called from
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
TEST_DIR="$SCRIPT_DIR/tests"
SOLUTION_DIR="$SCRIPT_DIR/solutions"

# Load the configuration file if it exists
for path in "$SCRIPT_DIR" ~; do
    if [[ -f "$path/.subparrc" ]]; then
        source "$path/.subparrc"
        break
    fi
done

# Slurp up all of the command line arguments into the command to test
CMD="$@"

num_passed=0
num_tests=0

echo "Running tests..."
for test in "$TEST_DIR"/*; do
    filename=$(basename -- "$test")

    if [[ $filename == '*' ]]; then
        echo "Warning: no tests found!"
    else
        (( num_tests++ ))
        printf "Test $filename: "
        output=$(cat "$test" | $CMD 2>&1)

        if [[ $? -ne 0 ]]; then
            echo "Failed with error: $output"
            break
        fi

        # If the solution file is Unix formatted, ensure that the output
        # doesn't contain any carriage returns
        if [[ $(grep -c $'\r' "$SOLUTION_DIR/$filename") -eq 0 ]]; then
            output=$(echo "$output" | tr -d '\r')
        fi

        difference=$(echo "$output" | cmp "$SOLUTION_DIR/$filename" 2>&1)

        if [[ $difference ]]; then
            echo "failed..."
            
            if [[ $PRINT_ERRORS ]]; then
                echo "$difference"
            fi

            if [[ $STOP_EARLY ]]; then
                break
            fi
        else
            (( num_passed++ ))
            echo "passed!"
        fi
        
    fi
done

if [[ $num_tests -gt 0 ]]; then
    echo "Tests passed: $num_passed/$num_tests"
fi

# Assumes that if there is more than one token in the command, the first token
# is a runtime like "python" or "bash", and the rest of the command is the
# actual file
size=$(cat ${CMD#* } | wc --chars)
echo "File size: ${size% *}"
