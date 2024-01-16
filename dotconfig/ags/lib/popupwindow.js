import AgsWindow from "resource:///com/github/Aylur/ags/widgets/window.js";
import GObject from "gi://GObject";
import { Widget } from "resource:///com/github/Aylur/ags/widget.js";
import App from "resource:///com/github/Aylur/ags/app.js";

/**
 * @typedef {import('types/widgets/revealer').default} AgsRevealer
 */

class PopupWindow extends AgsWindow {
  static {
    GObject.registerClass(this);
  }

  /**
   * @param {import('types/widgets/window').WindowProps & {
   *  name: string
   *  child: import('types/widgets/box').default
   *  transition?: import('types/widgets/revealer').RevealerProps['transition']
   * }} o
   */
  constructor({ name, child, transition = "none", visible = false, ...rest }) {
    super({
      ...rest,
      name,
      popup: true,
      focusable: true,
    });

    /** @type {AgsRevealer} */
    this.revealer = Widget.Revealer({
      transition,
      child,
      transition_duration: 200,
      css: `
        transition-timing-function: ease-in;
      `,
      connections: [
        [
          // @ts-ignore
          App,
          (_, wname, visible) => {
            // @ts-ignore
            if (wname === name) this.revealer.reveal_child = visible;
          },
        ],
      ],
    });

    this.child = Widget.Box({
      child: this.revealer,
      css: "padding: 1px;",
    });
    this.show_all();
    this.visible = visible;
  }

  set transition(dir) {
    this.revealer.transition = dir;
  }
  get transition() {
    return this.revealer.transition;
  }
}

/** @param {import('types/widgets/window').WindowProps & {
 *      name: string
 *      child: import('types/widgets/box').default
 *      transition?: import('types/widgets/revealer').RevealerProps['transition']
 *  }} config
 */
export default (config) => new PopupWindow(config);
