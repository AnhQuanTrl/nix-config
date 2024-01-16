import Mpris from "resource:///com/github/Aylur/ags/service/mpris.js";
import Variable from "resource:///com/github/Aylur/ags/variable.js";
import Widget from "resource:///com/github/Aylur/ags/widget.js";

export default () => {
  /** @type {import('types/service/mpris').MprisPlayer|null} */
  let currentPlayer = null;

  const coverArt = Widget.Box({
    class_name: "cover",
  });

  const title = Widget.Label({
    class_name: "title",
    label: "Not Playing",
    truncate: "end",
  });

  const artist = Widget.Label({
    class_name: "artist",
    label: "",
  });

  const play = Widget.Button({});

  const panel = Widget.Box({
    vexpand: false,
    children: [],
  });

  return Widget.Box({
    class_name: "music",
    vertical: true,
    children: [
      Widget.Box({
        class_name: "content",
        children: [
          coverArt,
          Widget.Box({
            hpack: "start",
            vpack: "center",
            vertical: true,
            hexpand: true,
            children: [title, artist],
          }),
        ],
      }),
      panel,
    ],
    connections: [
      [
        Mpris,
        (self) => {
          const players = Mpris.players;
          if (players.length <= 0) {
            return;
          }
          let player = players.find((p) => p.play_back_status === "Playing");
          if (!player) {
            player = players[0];
          }

          if (currentPlayer?.identity === player.identity) {
            return;
          }
          currentPlayer = player;

          console.log(player.track_artists);

          coverArt.css = `
              background-image: url("${player.cover_path}");
            `;
          title.label = player.track_title;
          artist.label = player.track_artists.join(", ");
        },
      ],
    ],
  });
};
