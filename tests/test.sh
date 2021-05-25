#!/bin/bash

usage() {
    echo 'Usage:'
    echo "$0 labdir testfile.sh -- run a test"
    echo "$0 labdir testdir -- run all tests in a dir"
}

test_file() {
    echo "Running test file $1"

    machine=pc_int

    while read line ; do
        if [[ $line == -* ]]; then
            machine="${line:1}"
            echo "Now executing commands on machine $machine"
        elif [[ ! -z $line ]] && [[ ! $line == \#* ]]; then
            echo "$machine# $line"
            kathara exec $machine -- $line
            echo
        fi
    done < $1
}

if [ "$#" -ne 2 ]; then
    usage
    exit
fi

lab_dir="$(pwd)"/$1
test_f="$(pwd)"/$2
cd $lab_dir

if [[ ! -d $lab_dir ]]; then
    echo "$lab_dir not a directory!"
    usage
    exit
elif [[ -d $test_f ]]; then
    for f in $test_f/*; do
        test_file $f
    done
elif [[ -f $test_f ]]; then
    test_file $test_f
else
    echo "$test_f is not a file or directory."
    usage
    exit
fi

