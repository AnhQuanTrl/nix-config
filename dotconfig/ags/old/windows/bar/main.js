import { Widget } from "resource:///com/github/Aylur/ags/widget.js";
import { ModuleWorkspaces } from "./workspaces.js";
import { ModuleLaunchers } from "./launchers.js";
import { ModuleSysTray } from "./systray.js";
import { ModuleDashboard } from "./dashboard.js";

export default () =>
  Widget.Window({
    name: "bar",
    exclusivity: "exclusive",
    anchor: ["left", "top", "bottom"],
    child: Widget.CenterBox({
      class_name: "bar",
      vertical: true,
      start_widget: ModuleLaunchers(),
      center_widget: ModuleWorkspaces(),
      end_widget: Widget.Box({
        vpack: "end",
        spacing: 16,
        vertical: true,
        hexpand: false,
        children: [ModuleSysTray(), ModuleDashboard()],
      }),
    }),
  });
