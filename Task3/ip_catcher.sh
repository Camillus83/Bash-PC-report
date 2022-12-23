#!/bin/bash
#####################################################
# NAME
#   ip_catcher.sh - Returns all IP addresses from apache log file.
#                   Calculating how much requests being made for each IP.
#                   Saving results in txt file.
#
#####################################################

filename="access.log" # Name of apache log file, should be in the same directory.
outputFilename="ip_list.txt" # Name of file where results will be saved.

cat $filename | awk '{print $1}' | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}"| sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n | uniq -c | awk '{print $2": " $1}' >  $outputFilename
