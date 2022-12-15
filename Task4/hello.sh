#!/bin/bash

logged_user="$(whoami)"
inp=""


function f1 {
    inp=$1
    if [[ "$inp" == "cores" ]]; then nproc
    elif [[ "$inp" == "disk" ]]; then df -h /
    elif [[ "$inp" == "ram" ]]; then free -m
    elif [[ "$inp" == "lastlogs" ]]; then last -n 10
    elif [[ "$inp" == "pyprocs" ]]; then ps aux | grep python | wc | awk '{ print $1 }'
    elif [[ "$inp" == "perlprocs" ]]; then ps aux | grep perl | wc | awk '{ print $1 }'
    elif [[ "$inp" == "q" ]]; then exit 1
    else echo "Unknown command"
    fi
}


if [ $# -eq 0 ]; then
    echo "Hello" $logged_user
    echo "What do you want to check?"
    echo "Type 'cores' for CPU core info"
    echo "Type 'disk' for disk space info"
    echo "Type 'ram' for ram info"
    echo "Type 'lastlogs' for info about last logged in users"
    echo "Type 'pyprocs' to calculate the number of active python process"
    echo "Type 'perlprocs' to calculate the number of active python process"
    echo "Type 'q' to exit script"
    while [ true ];
    do
        read -p ">>" inp
        f1 $inp
    done
else
    f1 $1
fi

