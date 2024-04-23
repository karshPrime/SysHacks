#!/usr/bin/env bash

SOURCE="/sys/class/power_supply/"

if [ ! -d "$SOURCE/BAT0" ]; then
    if [ ! -d "$SOURCE/BAT1" ]; then
        if [ ! -d "$SOURCE/BATT" ]; then
            echo 'Device Not supported'
            exit 1
        else BAT='BATT'
        fi
    else BAT='BAT1'
    fi
else BAT='BAT0'
fi

if [ ! -f "$SOURCE/$BAT/charge_control_end_threshold" ]; then
    echo 'Device Not supported'
    exit 1
else
    read -p "Enter battery charge limit: " LIMIT
fi

CMD="echo $LIMIT | tee $SOURCE/$BAT/charge_control_end_threshold"

SCRIPT="[Unit]\n\
Description=Set the battery charge threshold\n\
After=multi-user.target\n\
StartLimitBurst=0\n\
\n\
[Service]\n\
Type=oneshot\n\
Restart=on-failure\n\
ExecStart=/bin/bash -c '$CMD'\n\
\n\
[Install]\n\
WantedBy=multi-user.target"

sudo echo -e $SCRIPT >> /etc/systemd/system/battery-charge-threshold.service
sudo systemctl enable --now battery-charge-threshold.service
