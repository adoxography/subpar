#!/usr/bin/bash

# Relocate to the script's directory so that the test and solution directories
# can be found regardless of where the script was called from
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
TEST_DIR="$SCRIPT_DIR/tests"
SOLUTION_DIR="$SCRIPT_DIR/solutions"

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
        output=$(cat "$test" | $CMD)
        
        # Compare the output of the command to the stored solution, but remove
        # any lurking carriage returns along the way
        difference=$(echo "$output" | tr -d '\r' | cmp "$SOLUTION_DIR/$filename")

        if [[ $difference ]]; then
            echo "$difference"
            echo "failed..."
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
