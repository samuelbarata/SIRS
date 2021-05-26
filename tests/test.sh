#!/bin/bash

YELLOW='\033[1;33m'
LIGHTRED='\033[0;31m'
LIGHTCYAN='\033[1;36m'
LIGHTGREEN='\033[1;32m'
LIGHTBLUE='\033[1;34m'
CYAN='\033[0;36m'
NC='\033[0m'


usage() {
    echo 'This script recieves a test file or directory with test files and executes them.'
    echo 'Additionally, this script needs to recieve the directory in which lab.conf exists. This is needed for kathara exec to find the machine to run the test on.'
    echo 'Usage:'
    echo "$0 labdir testfile.sh -- run a test"
    echo "$0 labdir testdir -- run all tests in a directory"
}


# Recieves a test file and executes it
# Test file syntax:
# A line starting with a hash ("#") defines a comment and is ignored
# A line starting with a dash ("-") defines which machine the following commands will be executed
# A line starting with an arrow (">") defines a string to be written to the (host) terminal by the test script
# A line starting with a bang ("!") reads the command queue and execs them on the last defined machind.
# A line that doesn't start with any of those symbols defines a command that will be queued to run
test_file() {
    echo -ne $YELLOW
    echo "Running test file $1"
    echo -ne $NC
    echo

    machine=pc_int
    commands=""

    # Read the test file line by line
    while read line ; do
        if [[ $line == -* ]]; then      # Machine definitions
            machine="${line:1}"
        elif [[ $line == \>* ]]; then   # Print definitions
            echo "${line:1}"
        elif [[ $line == \!* ]]; then   # Execute definitions
            # Print machine in light blue
            echo -ne $LIGHTBLUE
            echo "Machine: $machine"
            echo -ne $NC

            commands=${commands:1}

            # Print comamnds to execute in cyan
            echo -ne $CYAN
            while IFS= read -r com; do
                echo ">> $com"
            done <<< "$commands"
            echo -ne $NC

            commands=$(tr '\n' ';' <<< $commands)

            # Execute commandsin kathara, save result in result variable
            result=$(eval "kathara exec -d $2 $machine -- bash -c \"$commands\"")
            if [[ ! -z $result ]]; then
                # Parse each line of the output
                while IFS= read -r r; do
                    parse_output "$r"
                done <<< $result
            fi
            echo
            commands=""
        elif [[ ! -z $line ]] && [[ ! $line == \#* ]]; then # Command Lines
            printf -v commands "$commands\n$line"
        fi
    done < $1
}


# Very ugly function
parse_output() {
    output=$1
    if echo $output | grep -qi 'success'; then
        if echo $output | grep -qi 'unintended'; then
            echo -ne $LIGHTRED
        else
            echo -ne $LIGHTGREEN
        fi
    elif echo $output | grep -qi 'failure'; then
        if echo $output | grep -qi 'intended' && echo $output | grep -qiv 'unintended'; then
            echo -ne $LIGHTGREEN
        else
            echo -ne $LIGHTRED
        fi
    else 
        echo -ne $LIGHTCYAN
    fi
    echo "<< $output"
    echo -ne $NC

}


##### Script Start #####

if [ "$#" -ne 2 ]; then
    usage
    exit
fi

lab_dir=`realpath $1`
test_f=`realpath $2`

# Make sure lab_dir is a directory, otherwise print usage and leave
if [[ ! -d $lab_dir ]]; then
    echo "$lab_dir not a directory!"
    usage
    exit
# If test_f is a directory, call test_file function with each file in the directory
elif [[ -d $test_f ]]; then
    for f in $test_f/*; do
        test_file $f $lab_dir
        echo $'\n'
    done
# If test_f is a file, call test_file with it
elif [[ -f $test_f ]]; then
    test_file $test_f $lab_dir
# If test_f is neither file nor directory is doesn't exist, print usage and leave
else
    echo "$test_f is not a file or directory."
    usage
    exit
fi

