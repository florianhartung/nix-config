{
  pkgs,
  config,
  lib,
  inputs,
  project-lib,
  ...
}:
let
  cfgEnable = config.programs.firefox.enableOpinionatedConfig;
in
{
  options.programs.firefox.enableOpinionatedConfig = lib.mkEnableOption "opinionated config for firefox";

  config = lib.mkIf cfgEnable {
    programs.firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      profiles.default = {
        # Only load bookmarks on initial setup
        # bookmarks = import ./bookmarks.nix;
        # settings = import ./settings.nix { inherit config project-lib; };
        extensions.packages = import ./extensions.nix {
          inherit pkgs;
          inherit (inputs) firefox-addons;
        };
        search = {
          engines = import ./search-engines.nix;
          force = true;

          default = "ddg";
          privateDefault = "ddg";
        };
        userContent = ''
          @-moz-document url("about:home"), url("about:newtab") {
            body {
              background-image: url("https://wallpapers.com/images/hd/cozy-anime-1920-x-1080-vit526qd39q6oh4z.jpg") !important;
              background-repeat: no-repeat !important;
              background-position: center !important;
              background-size: cover !important;
              background-attachment: fixed !important; 
              background-color: rgba(255, 230, 200, 0.35) !important;
              background-blend-mode: multiply !important;
            }
            main {
              justify-content: start;
            }
          }        
        '';
      };
    };
  };
}
