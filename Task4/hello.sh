#!/bin/bash

logged_user="$(whoami)"

function showHelp {
    echo "What do you want to check?"
    echo "Type 'cores' for CPU core info"
    echo "Type 'disk' for disk space info"
    echo "Type 'ram' for ram info"
    echo "Type 'lastlogs' for info about last logged in users"
    echo "Type 'pyprocs' to calculate the number of active python process"
    echo "Type 'perlprocs' to calculate the number of active python process"
    echo "Type 'pyperlprocs' to calculate the number of active python/perl process"
    echo "Type 'help' for commands"
    echo "Type 'q' to exit script"
}

function f2 {
    inputVal=$1
    case $inputVal in 
    "cores")
        answer=$(nproc)
        echo "Number of CPU cores: $answer"
        ;;
    "disk")
        answer=$(df | awk '{sum+=$4} END {printf "%.02f", sum/1e6}')
        echo "You have $answer GB of memory free."
        ;;
    "ram")
        answer=$(free -m | awk '{sum+=$2} END {printf "%.0f", sum/1e3}')
        echo "You have $answer GB of total ram."
        ;;
    "lastlogs")
        echo "Last 5 users logged in:"
        last -n 10 | grep -v 'reboot' | awk '{print $1}' | head -n -2
        ;;
    "pyprocs")
        answer=$(ps aux | grep python | wc | awk '{ print $1 }')
        echo "Number of active Python process: $answer"
        ;;
    "perlprocs")
        answer=$(ps aux | grep perl | wc | awk '{ print $1 }')
        echo "Number of active Perl process: $answer"
        ;;
    "pyperlprocs")
        answer=$(ps aux | grep -E 'perl|python' | wc | awk '{ print $1 }')
        echo "Number of active Python/Perl process: $answer"
        ;;
    "help")
        showHelp
        ;;
    "q")
        exit 1;;
    *)
        echo "Unknown command";;
    esac
}


if [ $# -eq 0 ]; then
    echo "Hello" $logged_user
    showHelp
    while [ true ];
      do
        read -p ">> " inputVal
        f2 $inputVal
      done
else
    f2 $1
fi
