import * as Utils from "resource:///com/github/Aylur/ags/utils.js";

/** @param {import('types/service/applications').Application} app */
export const launchApp = (app) => {
  Utils.execAsync(["hyprctl", "dispatch", "exec", `sh -c ${app.executable}`]);
  app.frequency += 1;
};
