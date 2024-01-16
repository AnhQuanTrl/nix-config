import Widget from "resource:///com/github/Aylur/ags/widget.js";

/**
 * @typedef {import('types/widgets/box').BoxProps & {
 *    button: import('types/widgets/button').default
 *    direction?: 'left' | 'right' | 'down' | 'up'
 *    duration?: number
 * }} ButtonRevealerProps
 */

/** @param {ButtonRevealerProps} props */
export default ({
  button,
  child,
  direction = "left",
  duration = 300,
  ...rest
}) => {
  const vertical = direction === "down" || direction === "up";
  const posStart = direction === "down" || direction === "right";
  const posEnd = direction === "up" || direction === "left";

  const revealer = Widget.Revealer({
    transition: `slide_${direction}`,
    transition_duration: duration,
    child,
  });

  button.on_clicked = () => (revealer.reveal_child = !revealer.reveal_child);
  return Widget.Box({
    ...rest,
    vertical,
    children: [
      // @ts-ignore
      posStart && button,
      revealer,
      // @ts-ignore
      posEnd && button,
    ],
  });
};
