#!/bin/bash
#####################################################################
# NAME
#   host_ips.sh - Returns all ip addresess asigned to the host from ifconfig
#                 output. Presented in alphabetical order in txt file.
#####################################################################

outputFilename="host_ips.txt"

ifconfig | grep -Eo 'inet ([0-9]{1,3}\.){3}[0-9]{1,3}*' | awk '{ print $2 }' | sort > $outputFilename
