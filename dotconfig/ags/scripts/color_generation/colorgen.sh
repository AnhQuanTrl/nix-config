#!/usr/bin/bash

# check if no arguments
if [ $# -eq 0 ]; then
  echo "Usage: colorgen.sh /path/to/image (--apply)"
fi

# check if the file ~/.cache/ags/user/colormode.txt exists. if not, create it. else, read it to $lightdark
colormode_path="$HOME/.cache/ags/user/colormode.txt"
lightdark=""
if [ ! -f "$colormode_path" ]; then
  echo "" >"$colormode_path"
else
  lightdark=$(cat "$colormode_path") # either "" or "-l"
fi

cd "$HOME/.config/ags/scripts/" || exit
generated_color_path="$HOME/.cache/ags/user/generated_colors.txt"
if [[ "$1" = "#"* ]]; then
  color_generation/generate_colors_material.mjs --color "$1" "$lightdark" >"$generated_color_path"
  if [ "$2" = "--apply" ]; then
    cp "$generated_color_path" "$HOME/.config/ags/scss/_material.scss"
    color_generation/applycolor.sh
  fi
else
  color_generation/generate_colors_material.mjs --path "$1" "$lightdark" >"$generated_color_path"
  if [ "$2" = "--apply" ]; then
    cp "$generated_color_path" "$HOME/.config/ags/scss/_material.scss"
    color_generation/applycolor.sh
  fi
fi
