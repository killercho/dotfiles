#!/bin/bash

BATTERY_INFO_DIRECTORY=/sys/class/power_supply/BAT0
LOW_BATTERY_THRESHHOLD=15 # in percentage
SLEEP_TIME=150 # in seconds

while true
do
    CAPACITY=$(cat $BATTERY_INFO_DIRECTORY/capacity)
    STATUS=$(cat $BATTERY_INFO_DIRECTORY/status)

    if [[ $CAPACITY -le $LOW_BATTERY_THRESHHOLD && $STATUS == "Discharging" ]]
    then
        DISPLAY=:0.0 /usr/bin/notify-send "Battery critical!" "Only $CAPACITY% left. Plug the charger!"
    fi

    sleep $SLEEP_TIME
done
