import App from "resource:///com/github/Aylur/ags/app.js";
import { lookUpIcon } from "resource:///com/github/Aylur/ags/utils.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

/**
 * @typedef {import("types/widgets/button").default} AgsButton
 * @typedef {import("types/service/applications").Application} Application
 */

/**
 * @typedef {object} AppItem
 * @extends AgsButton
 * @property {Application} app
 */

/**
 * @param {import('resource:///com/github/Aylur/ags/service/applications.js').Application} app
 * @returns {AppItem}
 */
export default (app) => {
  const title = Widget.Label({
    label: app.name,
    xalign: 0,
    vpack: "center",
    class_name: "title",
    truncate: "end",
  });

  const description = Widget.Label({
    label: app.description || "",
    wrap: true,
    xalign: 0,
    justification: "left",
    class_name: "description",
    vpack: "center",
  });

  const icon = Widget.Icon({
    icon: lookUpIcon(app.icon_name || "") ? app.icon_name || "" : "",
    size: 52,
  });

  const textBox = Widget.Box({
    vertical: true,
    vpack: "center",
    children: app.description ? [title, description] : [title],
  });

  /** @type {AppItem} */
  return Widget.Button({
    class_name: "item horizontal",
    // @ts-ignore
    setup: (self) => (self.app = app),
    on_clicked: () => {
      App.closeWindow("applauncher");
      app.launch();
    },
    child: Widget.Box({
      children: [icon, textBox],
    }),
  });
};
