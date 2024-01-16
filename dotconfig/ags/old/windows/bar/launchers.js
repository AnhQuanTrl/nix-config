import Gtk from "gi://Gtk";
import App from "resource:///com/github/Aylur/ags/app.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import { Widget } from "resource:///com/github/Aylur/ags/widget.js";

/** @param { { label: string, font_size: number, on_clicked?: import('types/widgets/button').ButtonProps['on_clicked'] } } o */
const LauncherItem = ({ label, font_size, on_clicked = undefined }) =>
  Widget.Button({
    hpack: "center",
    child: Widget.Label({
      label,
      justification: "center",
      css: `
        font-size: ${font_size}px;
      `,
    }),
    on_clicked: on_clicked ?? (() => {}),
  });

export const ModuleLaunchers = () =>
  Widget.Box({
    vertical: true,
    spacing: 20,
    hexpand: false,
    class_name: "launcher",
    children: [
      LauncherItem({
        label: "󱓞",
        font_size: 18,
        on_clicked: () => {
          App.toggleWindow("applauncher");
        },
      }),
      LauncherItem({
        label: "",
        font_size: 16,
        on_clicked: () => Utils.execAsync("firefox"),
      }),
      LauncherItem({
        label: "",
        font_size: 20,
        on_clicked: () => Utils.execAsync("alacritty"),
      }),
      LauncherItem({
        label: "",
        font_size: 16,
      }),
    ],
  });
