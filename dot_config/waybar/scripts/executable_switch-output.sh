#!/bin/bash

waybar_dir="${HOME}/.config/waybar"
config_file="${waybar_dir}/config"

to=$1

if [ "$to" == "multi" ]; then
  waybar_to="Lenovo Group Limited P27h-20 V9075P1R"
else
  waybar_to="eDP-1"
fi

pushd "$waybar_dir" || exit
sed -i "s/^  \"output\":.*,$/  \"output\": \"$waybar_to\",/" $config_file
popd || exit

echo "${to} activated successfully!" >> /tmp/foo

pkill waybar
waybar &
