import Widget from "resource:///com/github/Aylur/ags/widget.js";
import PopupWindow from "../../lib/popupwindow.js";
import Header from "./header.js";
import UserWelcome from "./user-welcome.js";
import Music from "./music.js";

export default () => {
  const body = Widget.Box({
    vertical: true,
    class_name: "body",
    children: [
      Widget.Box({
        spacing: 8,
        children: [UserWelcome(), Music()],
      }),
    ],
  });
  return PopupWindow({
    name: "dashboard",
    transition: "slide_right",
    anchor: ["left", "top", "bottom"],
    child: Widget.Box({
      class_name: "dashboard",
      vexpand: true,
      vertical: true,
      children: [Header(), body],
    }),
  });
};
