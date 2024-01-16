import Widget from "resource:///com/github/Aylur/ags/widget.js";
import { USER_NAME } from "../../constants.js";

export default () => {
  const avatar = Widget.Box({
    class_name: "avatar",
  });

  const hello = Widget.Box({
    spacing: 16,
    vpack: "center",
    children: [
      avatar,
      Widget.Label({
        class_name: "greeting",
        label: `Hello ${USER_NAME}`,
      }),
    ],
  });

  const searchBox = Widget.Button({
    class_name: "search-box horizontal",
    vpack: "center",
    hexpand: true,
    child: Widget.Box({
      children: [
        Widget.Icon({
          icon: "folder-saved-search-symbolic",
          size: 16,
        }),
        Widget.Label({
          label: "Search...",
        }),
      ],
    }),
  });

  return Widget.Box({
    hexpand: true,
    vpack: "start",
    spacing: 28,
    vertical: false,
    class_name: "header",
    children: [hello, searchBox],
  });
};
