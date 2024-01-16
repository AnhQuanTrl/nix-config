import Widget from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import { USER_NAME } from "../../constants.js";
import Gtk from "gi://Gtk";

export default () => {
  const avatar = Widget.Box({
    class_name: "avatar",
  });

  const uptime = Widget.Label({
    hpack: "center",
    label: "",
    connections: [
      [
        10000,
        (self) => {
          const result = Utils.exec("uptime -p");
          self.label = result.split(",").slice(0, 2).join(",");
        },
      ],
    ],
  });

  const panel = Widget.Box({
    class_name: "panel",
    vexpand: false,
    children: [
      Widget.Button({
        hpack: "start",
        vpack: "center",
        class_name: "btn-powermenu btn",
        child: Widget.Label("󰐦"),
      }),
      Widget.Box({
        hexpand: true,
        hpack: "end",
        vpack: "center",
        class_name: "buttons-end horizontal",
        children: [
          Widget.Button({
            class_name: "btn-reboot btn",
            child: Widget.Label("󰑓"),
          }),
          Widget.Button({
            class_name: "btn-shutdown btn",
            child: Widget.Label("⏻"),
          }),
        ],
      }),
    ],
  });

  return Widget.Box({
    class_name: "user-welcome",
    vertical: true,
    hexpand: false,
    children: [
      Widget.Box({
        class_name: "content",
        children: [
          avatar,
          Widget.Box({
            vertical: true,
            hexpand: true,
            hpack: "center",
            vpack: "center",
            class_name: "welcome vertical",
            children: [
              Widget.Label({
                hpack: "center",
                class_name: "msg",
                label: `Welcome ${USER_NAME}`,
              }),
              uptime,
            ],
          }),
        ],
      }),
      panel,
    ],
  });
};
