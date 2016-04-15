#!/bin/bash
#
# W. H. Bell
#
# A script to install dependencies and configure the serial port
# to use the BrickPi with a Raspberry Pi that is running Raspbian Jessie
#

install_deps() {
  sudo apt-get install -y python-serial python-dev
  pip install BrickPi
}

configure_serial() {
  # If needed, set a higher rate serial clock
  grep "init_uart_clock=32000000" /boot/config.txt &> /dev/null
  if [[ $? != 0 ]]; then
    echo "" >> /boot/config.txt
    echo "# Needed for BrickPi " >> /boot/config.txt
    echo "init_uart_clock=32000000" >> /boot/config.txt
  fi

  # If needed, free up the serial port from being a console
  grep "console=serial0,115200" /boot/cmdline.txt &> /dev/null
  if [[ $? == 0 ]]; then
    sed -i -e 's/console=serial0,115200 //g' /boot/cmdline.txt
  fi
}

install_deps
configure_serial
