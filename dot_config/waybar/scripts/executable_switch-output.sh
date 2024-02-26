#!/bin/bash

waybar_dir="${HOME}/.config/waybar"
config_file="${waybar_dir}/config"
primary_monitor=$(grep Lenovo "${HOME}/.config/kanshi/config" | head -1 | awk -F\" '{print $2}')

to=$1

if [ "$to" == "multi" ]; then
  waybar_to=$primary_monitor
else
  waybar_to="eDP-1"
fi

pushd "$waybar_dir" || exit
sed -i "s/^  \"output\":.*,$/  \"output\": \"$waybar_to\",/" "$config_file"
popd || exit

echo "${to} activated successfully!" >> /tmp/foo

pkill waybar
waybar &
