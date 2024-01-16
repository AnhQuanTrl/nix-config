#!/usr/bin/env bash

sleep 0
cd "$HOME/.config/ags" || exit

colornames=$(cat scss/_material.scss | cut -d: -f1)
colorstrings=$(cat scss/_material.scss | cut -d: -f2 | cut -d ' ' -f2 | cut -d ";" -f1)
IFS=$'\n'
colorlist=($colornames)
colorvalues=($colorstrings)

apply_hyprland() {
  if [ ! -f "scripts/templates/hypr/colors.conf" ]; then
    echo "Template file not found for Hyprland colors. Skipping that."
    return
  fi

  cp "scripts/templates/hypr/colors.conf" "$HOME/.config/hypr/colors_new.conf"
  for i in "${!colorlist[@]}"; do
    sed -i "s/{{ ${colorlist[$i]} }}/${colorvalues[$i]#\#}/g" "$HOME/.config/hypr/colors_new.conf"
  done
}

apply_hyprland
