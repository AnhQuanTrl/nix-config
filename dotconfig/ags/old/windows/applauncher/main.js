import Applications from "resource:///com/github/Aylur/ags/service/applications.js";
import PopupWindow from "../../lib/popupwindow.js";
import { Widget } from "resource:///com/github/Aylur/ags/widget.js";
import AppItem from "./appitem.js";
import App from "resource:///com/github/Aylur/ags/app.js";
import { launchApp } from "../../utils.js";

const WINDOW_NAME = "applauncher";

const AppLauncher = () => {
  const children = () => [
    ...Applications.query("").flatMap((app) => {
      const item = AppItem(app);
      return [
        Widget.Separator({
          hexpand: true,
          binds: [["visible", item, "visible"]],
        }),
        item,
      ];
    }),
    Widget.Separator({ hexpand: true }),
  ];
  const list = Widget.Box({
    vertical: true,
    children: children(),
  });

  const entry = Widget.Entry({
    visibility: true,
    class_name: "entry",
    primary_icon_name: "folder-saved-search-symbolic",
    text: "-",
    on_accept: ({ text }) => {
      const list = Applications.query(text || "");
      if (list[0]) {
        App.toggleWindow(WINDOW_NAME);
        launchApp(list[0]);
      }
    },
    on_change: ({ text }) =>
      list.children.map((item) => {
        // @ts-ignore
        if (item.app) {
          // @ts-ignore
          item.visible = item.app.match(text);
        }
      }),
  });

  return Widget.Box({
    vertical: true,
    class_name: "applauncher",
    children: [
      entry,
      Widget.Scrollable({
        hscroll: "never",
        class_name: "container",
        child: list,
      }),
    ],
    connections: [
      [
        // @ts-ignore
        App,
        (_, name, visible) => {
          if (name !== WINDOW_NAME) {
            return;
          }

          entry.text = "";
          if (visible) {
            entry.grab_focus();
          } else {
            list.children = children();
          }
        },
      ],
    ],
  });
};

export default () =>
  PopupWindow({
    name: WINDOW_NAME,
    transition: "slide_down",
    child: AppLauncher(),
  });
