#!/bin/bash
#####################################################################
# NAME
#   pid_catcher.sh - Returns PIDs of all the processes run from the
#                    current user. Save the results in pids.txt file.
#####################################################################

outputFilename="pids.txt"

ps aux | grep "^$USER" | awk '{print $2}' > $outputFilename

