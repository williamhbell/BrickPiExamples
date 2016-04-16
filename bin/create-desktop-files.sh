#!/bin/bash
#
# W. H. Bell
#
# A script to create desktop icons that link to each of the BrickPi Scratch
# programs.
#

# Need the full path, in case someone has given a relative path
full_path=$(readlink -f $0)

# Find the base directory.  This relies on the script being in the bin/ 
# directory.
base_dir=$(dirname $full_path)
base_dir=$(dirname $base_dir)

# Find the name of all of the Scratch files
# (This is not safe if someone has used a space in the
# file name!)
scratch_files=$(ls $base_dir/scratch/src/*.sb)

for file in $scratch_files; do
  cfg=${file%.sb}".cfg"
  if [[ ! -f "$cfg" ]]; then
    echo "Skipping \"$file\" since \"$cfg\" was not found"
    continue
  fi

  # Strip the suffix and directory to define the program name
  prog_name=${file%.sb}
  prog_name=$(basename $prog_name)

  # Define the desktop file name
  desktop_file="$HOME/Desktop/"$prog_name".desktop"

  # Create the desktop file
  cat > $desktop_file <<EOF
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=$prog_name
Comment=$prog_name
Icon=scratch
Exec=lxterminal -e $base_dir/bin/launchRpiScratchIO.sh $file -t "RpiScratchIO:$prog_name"
Terminal=false
EOF
done
