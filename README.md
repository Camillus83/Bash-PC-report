# Task1ExpertSoftserve

# Task 1
Please create three regex to match next tasks: 

## the current time in format hh:mm:ss
```
/^([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/
```
<a href="https://user-images.githubusercontent.com/87909623/208397150-416af536-e4ce-4d6e-a78c-258cdd43031b.png"> Evidence </a>
## ipv4 address
```
^(([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-5][0-5])\.){3}([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-5][0-5])$
```
<a href="https://user-images.githubusercontent.com/87909623/208397268-ed32fa04-7912-4b0c-b4ae-d27320125716.png">Link to evidence</a>

## whole paragraph of test text. Please pick up any text.
```
^.+\.\n$
```
<a href="https://user-images.githubusercontent.com/87909623/208397369-770ef09e-df17-44ed-a6b9-7b5eaf8d7ae8.png">Link to evidence</a>


# Task 2

Extract from 'ps' output pids of all the processes run from the current user
Extract all ip addresses(ipv4 and ipv6) assigned to the host from ifconfig output. Present them in alphabetical order.
```
ps aux | grep "^$USER" | awk '{print $2}' > pids.txt
```
<a href="https://github.com/Camillus83/Task1ExpertSoftserve/blob/main/Task2/pids.txt">pids.txt</a>

```
ifconfig | grep -Eo 'inet (([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-5][0-5])\.){3}([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-5][0-5])*' | awk '{ print $2 }' | sort -n
```
<a href="https://github.com/Camillus83/Task1ExpertSoftserve/blob/main/Task2/ip_list.txt">ip_list.txt</a>

# Task 3
Parse “access.log” file - find all unique IP addresses.
Group this IPs and sort them.
Calculate how much requests being made for each IP.
```
cat access.log | grep -E -o "^([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-5][0-5])\.([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-5][0-5])\.([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-5][0-5])\.([0-9]|[1-9][0-9]|[1][0-9][0-9]|[2][0-5][0-5])" | sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | uniq -c | awk '{print $2": "$1}' > ip_list.txt
```
<a href="https://github.com/Camillus83/Task1ExpertSoftserve/blob/main/Task3/ip_list.txt">ip_list.txt</a>

# Task 4
Write a bash script to check:

<li>Number of CPU Cores</li>
<li>Disk space</li>
<li>Size of RAM</li>
<li>Provide information about the last users which were login on the host</li>
<li>Calculate the number of active python/perl process</li>
<li>Create a cron job which will send a report information on email address</li>

User should be possible to choose what exactly he wants to check.
```
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
```

```
report.sh
#!/bin/bash

logged_user="$(whoami)"
today_date="$(date)"
cpu_cores="$(nproc)"
free_space="$(df | awk '{sum+=$4} END {printf "%.02f", sum/1e6}')"
ram="$(free -m | awk '{sum+=$2} END {printf "%.0f", sum/1e3}')"
last_logs="$(last -n 10 | grep -v 'reboot' | awk '{print $1}' | head -n -2)"
python_procs="$(ps aux | grep python | wc | awk '{ print $1 }')"
perl_procs="$(ps aux | grep perl | wc | awk '{ print $1 }')"

echo "Subject: DAILY PC REPORT"
echo "Hello $logged_user"
echo "Today is $today_date"
echo "PC report"
echo "Number of CPU cores $cpu_cores"
echo "You have $free_space GB free memory on disk."
echo "You have $ram GB of total ram."
echo "Last 5 user logged in:"
echo "$last_logs"
echo "Number of active Python process $python_procs"
echo "Number of active Perl process $perl_procs"
```

Cronjob
```
crontab -e
0 16 * * * /home/kamil/task1-from-expert/Task4/report.sh | ssmtp kamilrichter98@gmail.com
```

Result:
![image](https://user-images.githubusercontent.com/87909623/208456477-5fb0259e-85ce-4854-81c9-d2ebacfac9b7.png)
