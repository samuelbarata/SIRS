#!/bin/bash


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
    echo "Running test file $1"

    machine=pc_int
    commands=""

    while read line ; do
        if [[ $line == -* ]]; then
            machine="${line:1}"
        elif [[ $line == \>* ]]; then
            echo "${line:1}"
        elif [[ $line == \!* ]]; then
            echo "Machine: $machine"
            commands=${commands:1}
            while IFS= read -r com; do
                echo ">> $com"
            done <<< "$commands"
            commands=$(tr '\n' ';' <<< $commands)
            eval "kathara exec $machine -- bash -c \"$commands\""
            echo
            commands=""
        elif [[ ! -z $line ]] && [[ ! $line == \#* ]]; then
            printf -v commands "$commands\n$line"
        fi
    done < $1
}

if [ "$#" -ne 2 ]; then
    usage
    exit
fi

# We need to move to lab dir to execute kathara commands. Because of this we need absolute paths to the test files.
lab_dir=`realpath $1`
test_f=`realpath $2`
cd $lab_dir

# Make sure lab_dir is a directory, otherwise print usage and leave
if [[ ! -d $lab_dir ]]; then
    echo "$lab_dir not a directory!"
    usage
    exit
# If test_f is a directory, call test_file function with each file in the directory
elif [[ -d $test_f ]]; then
    for f in $test_f/*; do
        test_file $f
        echo $'\n'
    done
# If test_f is a file, call test_file with it
elif [[ -f $test_f ]]; then
    test_file $test_f
# If test_f is neither file nor directory is doesn't exist, print usage and leave
else
    echo "$test_f is not a file or directory."
    usage
    exit
fi

