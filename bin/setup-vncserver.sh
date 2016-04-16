#!/bin/bash
# W. H. Bell
#
# A script to install and configure tightvnc.
#
# -------------------------------------
# Global variables
vnc_user=pi

#--------------------------------------


vnc_script_path="/etc/init.d/tightvncserver"
vnc_script_name=$(basename $vnc_script_path)

check_user_id() {
  if [[ "$EUID" != 0 ]]; then
    echo "ERROR: this script should be run as root."
    exit 1
  fi
}

install_tightvncserver() {
  # Check if tightvncserver is installed and install it if needed.
  dpkg -s tightvncserver >& /dev/null
  if [[ $? != 0 ]]; then
    echo ">> Installing tightvncserver:"
    apt-get install -y tightvncserver
    if [[ $? != 0 ]]; then
      echo "ERROR: could not install tightvncserver"
      exit 1
    fi
  fi
}

create_initd_script() {
  vnc_home=$(eval echo ~$vnc_user)
  if [[ ! -f $vnc_script_path ]]; then
    echo ">> Creating $vnc_script_path"
    cat > $vnc_script_path <<EOF
#! /bin/sh
# $vnc_script_path

### BEGIN INIT INFO
# Provides: $vnc_script_name
# Required-Start: \$remote_fs \$syslog
# Required-Stop: \$remote_fs \$syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start VNC Server at boot time
# Description: Start VNC Server at boot time.
### END INIT INFO

USER=$vnc_user
HOME=$vnc_home

export USER HOME

case "\$1" in
 start)
  echo "Starting VNC Server"
  #Insert your favoured settings for a VNC session
  su - \$USER -c "/usr/bin/vncserver :1 -geometry 1280x800 -depth 16 -pixelformat rgb565"
  ;;

 stop)
  echo "Stopping VNC Server"
  /usr/bin/vncserver -kill :1
  ;;

 *)
  echo "Usage: $vnc_script_path {start|stop}"
  exit 1
  ;;
esac

exit 0
EOF
    if [[ $? != 0 ]]; then
      echo "ERROR: could not create $vnc_script_path"
      exit 1
    fi

    chmod 755 $vnc_script_path
  fi
}

create_vnc_passwd() {
  vnc_passwd=$(eval echo ~$vnc_user)"/.vnc/passwd"
  if [[ ! -f $vnc_passwd ]]; then
    su - $vnc_user -c "tightvncpasswd"
  fi
  if [[ ! -f $vnc_passwd ]]; then
    echo "ERROR: failed to create vnc passwd file"
    exit 1
  fi
}

check_user_id
install_tightvncserver
create_initd_script
create_vnc_passwd

# Enable the vnc boot script
update-rc.d $vnc_script_name defaults

#
# xsetroot -solid grey
#
# should become xsetroot -solid grey -cursor_name left_ptr
# in .vnc/xstartup (once the vnc server has been run once to create that file.)
