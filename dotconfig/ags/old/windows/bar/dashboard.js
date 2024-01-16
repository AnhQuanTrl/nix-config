import App from "resource:///com/github/Aylur/ags/app.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

export const ModuleDashboard = () =>
  Widget.Button({
    hpack: "center",
    class_name: "dashboard-revealer",
    child: Widget.Label({
      label: "",
    }),
    on_clicked: () => App.toggleWindow("dashboard"),
  });
