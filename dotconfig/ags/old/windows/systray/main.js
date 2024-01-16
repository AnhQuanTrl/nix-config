import Gtk from "gi://Gtk";
import Widget from "resource:///com/github/Aylur/ags/widget.js";
import SystemTray from "resource:///com/github/Aylur/ags/service/systemtray.js";
import PopupWindow from "../../lib/popupwindow.js";

/** @param {import('types/service/systemtray').TrayItem} item */
const SysTrayItem = (item) => {
  /** @param {import('gi://Gdk').Gdk.Event} event */
  const handlePrimaryClick = (event) => {
    const isAppindicator = ["nm-applet"].includes(item.id);
    if (isAppindicator || item.is_menu) {
      return item.openMenu(event);
    }

    return item.activate(event);
  };

  return Widget.Button({
    class_name: "item",
    child: Widget.Icon({
      size: 24,
      binds: [["icon", item, "icon"]],
    }),
    binds: [["tooltip-markup", item, "tooltip-markup"]],
    on_primary_click: (_, event) => handlePrimaryClick(event),
    on_secondary_click: (_, event) => item.openMenu(event),
  });
};

export default () =>
  PopupWindow({
    name: "systray",
    anchor: ["left", "bottom"],
    transition: "slide_right",
    child: Widget.Box({
      vertical: true,
      class_name: "systray",
      child: Widget.Scrollable({
        hscroll: "never",
        vscroll: "always",
        child: Widget.FlowBox({
          vpack: "start",
          orientation: Gtk.Orientation.HORIZONTAL,
          row_spacing: 20,
          column_spacing: 20,
          max_children_per_line: 4,
          connections: [
            [
              SystemTray,
              (self) => {
                SystemTray.items.forEach((item) =>
                  self.insert(SysTrayItem(item), -1),
                );
                self.show_all();
              },
              "notify::items",
            ],
          ],
        }),
      }),
    }),
  });
