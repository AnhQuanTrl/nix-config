import { App, Utils } from "./imports.js";

// Init cache
Utils.exec(`bash -c 'mkdir -p ~/.cache/user/colorschemes'`);
Utils.subprocess(
  [
    "inotifywait",
    "--recursive",
    "--event",
    "create,modify",
    "-m",
    App.configDir + "/scss",
  ],
  () => {
    console.log("scss reloaded");
    Utils.exec(
      `sassc ${App.configDir}/scss/main.scss ${App.configDir}/style.css`,
    );
    App.resetCss();
    App.applyCss(`${App.configDir}/style.css`);
  },
);

// Scss compilcation
Utils.exec(`sassc ${App.configDir}/scss/main.scss ${App.configDir}/style.css`);
App.resetCss();
App.applyCss(`${App.configDir}/style.css`);

export default {
  css: `${App.configDir}/style.css`,
  stackTraceOnError: true,
  closeWindowDelay: {
    // applauncher: 200,
    // systray: 300,
    // dashboard: 300,
  },
  // windows: [Bar(), AppLauncher(), SysTray(), Dashboard()],
};
