# Bash training


Bash script to check:

<li>Number of CPU Cores</li>
<li>Disk space</li>
<li>Size of RAM</li>
<li>Provide information about the last users which were login on the host</li>
<li>Calculate the number of active python/perl process</li>
<li>Cron job which will send a report information on email address</li>


```
#!/bin/bash
#####################################################
# NAME
#   pcreport.sh - Display informations about PC
#
# DESCRIPTION
#       calling ./pcreport.sh runs terminal program which
#       allows us to get informations about our pc.
#       We also can execute it fast by passing a parameter
#       and get fast response. For example:
#       ./pcreport.sh -c -r
#       displays a value of CPU cores and RAM.
#
# SYNOPSIS
#   ./pcreport.sh [options]
#
# OPTIONS
#       cores, -c, c
#               Display the amount of CPU cores
#       disk, -d, d
#               Display value of free memory on the hard disk
#       ram, -r, r
#               Display value of RAM
#       lastlogs, -ll, ll
#               Display last 5 users logged in
#       help, -h, h
#               Display help information about available options
#       quit, q, exit
#               Closing script
#       report
#               Display report written to email
#####################################################

logged_user="$(whoami)"

#################################################
# Get informations about available commands and functions.
# Arguments:
#   None
# Outputs:
#   User manual
#################################################
function showHelp {
    echo "What do you want to check?"
    echo "Type 'cores' for CPU core info"
    echo "Type 'disk' for disk space info"
    echo "Type 'ram' for ram info"
    echo "Type 'lastlogs' for info about last logged in users"
    echo "Type 'pyprocs' to calculate the number of active python process"
    echo "Type 'perlprocs' to calculate the number of active python process"
    echo "Type 'help' for commands"
    echo "Type 'q' to exit script"
}
#################################################
# Get value of CPU core.
# Arguments:
#   None
# Outputs:
#   Writes value of the number of CPU cores
#################################################
function checkCpuCores {
    answer=$(nproc)
    echo "Number of CPU cores: $answer"
}

##################################################
# Get the value of free memory on the hard disk.
# Arguments:
#   None
# Outpus:
#   Writes value of free memory on the hard disk
###################################################
function checkFreeDiskSpace {
    answer=$(df | awk '{sum+=$4} END {printf "%.02f", sum/1e6}')
    echo "You have $answer GB of free memory on your hard drive."
}

####################################################
# Get the value of RAM.
# Arguments:
#   None
# Outputs:
#   Writes RAM value
#####################################################
function checkRam {
    answer=$(free --mega | awk 'NR==2 {printf "%.1f", $2/1e3}')
    echo "You have $answer GB of ram."
}

#####################################################
# Get logins of last 5 logged in users.
# Arguments:
#   None
# Outputs:
#   Writes logins of last 5 logged in users
#####################################################
function lastLoggedUsers {
    echo "Last 5 users logged in:"
    last -n 10 | grep -v 'reboot' | awk '{print $1}' | head -n -2
}

#####################################################
# Get value of active Python processes
# Arguments:
#   None
# Outputs:
#   Writes value of active Python processes
#####################################################
function checkPythonProcs {
    answer=$(ps aux | grep python | grep -v grep | wc | awk '{ print $1 }')
    echo "Number of active Python process: $answer"
}

#####################################################
# Get value of active Perl processes
# Arguments:
#   None
# Outputs:
#   Writes value of active Perl processes
#####################################################
function checkPerlProcs {
    answer=$(ps aux | grep perl | grep -v grep | wc | awk '{ print $1 }')
    echo "Number of active Perl process: $answer"
}

#####################################################
# Generating a PC report to send to the user by email
# Arguments:
#   None
# Outputs:
#   Writes report, with subject, date, logged user
#   and values of checkCpuCore, checkFreeDiskSpace,
#   checkRam, lastLoggedUsers, checkPythonProcs, 
#   checkPerlProcs
#####################################################
function pcDailyReport {
    echo "Subject: DAILY PC REPORT"
    echo "Hello $(whoami)"
    echo "Today is $(date)"
    echo "PC REPORT"
    checkCpuCores
    checkFreeDiskSpace
    checkRam
    lastLoggedUsers
    checkPythonProcs
    checkPerlProcs
}

#########################################################
# Execute appropiate function depending on the parameter
# passed in.
# Arguments:
#   command or shortcut to our command
# Outputs:
#   Writes values of the performed function
#########################################################
function executeCommand {
    inputVal=$1
    case $inputVal in 
    "cores"|"-c"|"c")
        checkCpuCores ;;
    "disk"|"-d"|"d")
       checkFreeDiskSpace ;;
    "ram"|"-r"|"r")
        checkRam ;;
    "lastlogs"|"-ll"|"ll")
        lastLoggedUsers ;;
    "pyprocs"|"-pyp"|"pyp")
        checkPythonProcs ;;
    "perlprocs"|"-pep"|"pep")
        checkPerlProcs ;;
    "help"|"-h"|"h")
        showHelp ;;
    "quit"|"q"|"exit")
        exit 1 ;;
    "report")
        pcDailyReport ;;
    *)
        echo "Unknown command";;
    esac
}

#####################################################
#                    MAIN 
#####################################################
if [ $# -eq 0 ]; then
    echo "Hello" $logged_user
    showHelp
    while [ true ];
    do
        read -p ">> " inputVal
        executeCommand $inputVal
    done
else
    for parameter in "$@" 
    do
        executeCommand $parameter
    done
fi
```

Cronjob
```
crontab -e
0 16 * * * /home/kamil/task1-from-expert/Task4/pcreport.sh report | ssmtp kamilrichter98@gmail.com
```

Result:
![image](https://user-images.githubusercontent.com/87909623/208456477-5fb0259e-85ce-4854-81c9-d2ebacfac9b7.png)
