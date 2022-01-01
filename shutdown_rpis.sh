#!/usr/bin/env bash

rpis=( rpi2 rpi31 rpi32 )

function check_rpi () {
    computer=$1
    ping_received=$(ping -c 1 $computer | grep -i 'transmitted' | awk '{print $4}')
    echo $ping_received
}

for rpi in "${rpis[@]}"
do
    if [[ $(check_rpi $rpi) -eq 1 ]]
    then
        echo "Shutting down $rpi..."
        ssh $rpi -t sudo shutdown now
    else
        echo "RPi $rpi already stopped"
    fi
done