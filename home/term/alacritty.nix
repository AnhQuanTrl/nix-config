{
  config,
  options,
  pkgs,
  lib,
  ...
}: {
  config = {
    programs.alacritty = let
      theme = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "alacritty";
        rev = "main";
        hash = "sha256-w9XVtEe7TqzxxGUCDUR9BFkzLZjG8XrplXJ3lX6f+x0=";
      };
    in {
      enable = true;
      settings = {
        import = ["${theme}/catppuccin-mocha.yml"];
        font.normal.family = "FiraCode Nerd Font";
        # font.size = 13;
        window.decorations_theme_variant = "None";
      };
    };
  };
}
