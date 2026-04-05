#!/usr/bin/env bash
# Credits to end_4 on GitHub: https://github.com/end-4/dots-hyprland/blob/main/.config/hypr/hyprlock/status.sh
# Credits to mahaveergurjar for the battery icons part: https://github.com/mahaveergurjar/Hyprlock-Dots/blob/main/.config/hyprlock/scripts/battery.sh
############ Variables ############
enable_battery=false
battery_charging=false

# Get the paths (handling potential multiple batteries)
BAT_PATH=$(find /sys/class/power_supply/ -name "BAT*" | head -1)
if [[ -z "$BAT_PATH" ]]; then
  exit 0 # No battery found
fi

# Get the current battery percentage
battery_percentage=$(cat "$BAT_PATH/capacity") # $(cat /sys/class/power_supply/*/capacity | head -1) # $(cat /sys/class/power_supply/BAT0/capacity)

# Get the battery status (Charging or Discharging)
battery_status=$(cat "$BAT_PATH/status") # $(cat /sys/class/power_supply/*/status | head -1) == "Charging" # $(cat /sys/class/power_supply/BAT0/status)

# Define the battery icons for each 10% segment
battery_icons=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")

# Define the charging icon
charging_icon="󰂄"

# Calculate the index for the icon array
icon_index=$((battery_percentage / 10))
if [ "$icon_index" -gt 9 ]; then icon_index=9; fi # last icon should handle 90%-100%, as opposed to only handling 90%-99% and having a different icon for 100%

# Get the corresponding icon
battery_icon=${battery_icons[icon_index]}

####### Check availability ########
for battery in /sys/class/power_supply/*BAT*; do
  if [[ -f "$battery/uevent" ]]; then
    enable_battery=true
    if [[ $(cat /sys/class/power_supply/*/status | head -1) == "Charging" ]]; then
      battery_charging=true
    fi
    break
  fi
done

############# Output #############
if [[ $enable_battery == true ]]; then
  if [[ $battery_charging == true ]]; then
    echo -n "(+) $charging_icon"
  fi
  echo -n "$(cat /sys/class/power_supply/*/capacity | head -1)"%
  if [[ $battery_charging == false ]]; then
    echo -n " remaining $battery_icon"
  fi
fi

echo ''
