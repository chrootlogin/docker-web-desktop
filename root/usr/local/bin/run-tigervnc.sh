#!/usr/bin/env bash
set -eu

command="sudo -u user -H /usr/bin/vncserver -autokill -depth 24 -name desktop -xstartup /usr/bin/startxfce4 -SecurityTypes None"

# Proxy signals
function kill_app(){
    killall Xtigervnc
    exit 0 # exit okay
}
trap "kill_app" SIGINT SIGTERM

# Launch daemon
$command
sleep 2

# Loop while the pidfile and the process exist
while [ $(ps -ef | grep "Xtigervnc" | grep -v "grep" | wc -l) -eq 1 ]; do
    sleep 1
done

exit 127 # exit unexpected
