#!/bin/bash
#
# W. H. Bell
#
# A Bash script to launch RpiScratchIO and Scratch.  The script
# assumes that the name of the scratch file and the RpiScratchIO
# configuration are the same.  Therefore, somefile.sb (scratch file)
# and somefile.cfg (RpiScratchIO configuration).
#

usage() {
  echo "Usage: $0 <scratch file> [<RpiScratchIO cfg>]" 
  exit 1
}

# There must be at least one argument
if [[ $# < 1 or $# > 2 ]]; then
  usage
fi
scratch_file="$1"

# Check if the Scratch file can be found
if [[ ! -f "$scratch_file" ]]; then
  echo "ERROR: no file \"$scratch_file\" found"
  usage
fi

# Set the configuration file name
cfg=${scratch_file%.sb}".cfg"
if [[ $# == 2 ]]; then
  cfg=$2
fi

# Check if the configuration file can be found
if [[ ! -f "$cfg" ]]; then
  echo "ERROR: no configuration file \"$cfg\" found"
  usage
fi

# Kill all RpiScratchIO instances
killall RpiScratchIO &> /dev/null

# Kill all scratch (squeakvm) instances
killall squeakvm &> /dev/null

# Open the Scratch program
nohup scratch $scratch_file &> /dev/null &

# Wait until Scratch is running with port open
scratch_down=1
while [[ $scratch_down != 0 ]]; do
  nc 127.0.0.1 42001 < /dev/null
  scratch_down=$?
  if [[ $scratch_down != 0 ]]; then
    sleep 2
  fi
done

# Now launch RpiScratchIO
RpiScratchIO $cfg
