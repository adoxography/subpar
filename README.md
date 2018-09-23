# [subpar](https://github.com/adoxography/subpar)

## Requirements
The only requirement for `subpar` is bash. It is intended to work across all major platforms.

## Usage
* Clone the repo
* Add tests and solutions
* Run `./subpar.sh [command_to_run]`, making sure that `command_to_run` is EXACTLY as you would type it to run the command normally (e.g. if you would type `./cmd` or `python cmd`, don't use `cmd`)

## Defining tests
* Create a file in `/tests` with the input for the test
* Create an identically named file in `/solutions` with the expected output

## Configuration
By default, `subpar` will run through all available tests, and only report the success or failure of each test. (If your program crashes, `subpar` will always stop and report the error.)

To stop at the first failure, add `STOP_EARLY=1` to the start of the command.
To print the difference between the solution and your program's output, add `PRINT_ERRORS=1` to the start of the command.

You can also create a file called `.subparrc` in the framework root or in your home directory (`~`) with these variables. `subpar` will look first in the framework root before scanning the home directory for configuration files.
