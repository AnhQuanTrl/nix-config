import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

export const ModuleSysTray = () =>
  Widget.Button({
    hpack: "center",
    class_name: "systray-revealer",
    child: Widget.Label({
      label: "",
    }),
    on_clicked: () => App.toggleWindow("systray"),
  });
