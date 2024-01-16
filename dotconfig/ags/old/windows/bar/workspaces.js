import { Widget } from "resource:///com/github/Aylur/ags/widget.js";
import * as Utils from "resource:///com/github/Aylur/ags/utils.js";
import Gtk from "gi://Gtk";
import Hyprland from "resource:///com/github/Aylur/ags/service/hyprland.js";
/**
 * @typedef {import('types/widgets/box').default} AgsBox
 */
/**
 * @typedef {import('types/widgets/button').default} AgsButton
 */
/**
 * @typedef HyprWorkspace
 * @property {number} id
 * @property {number} windows
 */
const NUM_OF_WORKSPACES = 6;

export const ModuleWorkspaces = () =>
  Widget.Box({
    vertical: true,
    spacing: 16,
    class_name: "bar-ws-container",
    hexpand: false,
    children: Array.from({ length: NUM_OF_WORKSPACES }, (_, i) => i + 1).map(
      (i) =>
        Widget.Button({
          halign: Gtk.Align.CENTER,
          on_primary_click: () =>
            Utils.execAsync([
              "bash",
              "-c",
              `hyprctl dispatch workspace ${i} &`,
            ]).catch(print),
          child: Widget.Box({
            hpack: "center",
            class_name: "bar-ws",
            connections: [
              [
                Hyprland,
                (self) => {
                  self.toggleClassName(
                    "bar-ws-active",
                    Hyprland.active.workspace.id === i,
                  );
                },
              ],
            ],
          }),
        }),
    ),
    connections: [
      [
        Hyprland,
        (self) => {
          const kids = /** @type {AgsButton[]} */ (self.children);
          const occupied = Array.from({ length: NUM_OF_WORKSPACES }, (_, i) => {
            const ws = /** @type {HyprWorkspace|undefined} */ (
              Hyprland.getWorkspace(i + 1)
            );
            return (ws?.windows ?? 0) > 0;
          });
          for (let i = 0; i < occupied.length; i++) {
            const box = /** @type {AgsBox} */ (kids[i].child);
            if (!occupied[i]) {
              continue;
            }
            box.get_style_context().has_class("bar-ws-occupied")
              ? null
              : box.toggleClassName("bar-ws-occupied");
          }
        },
        "notify::workspaces",
      ],
    ],
  });
