{ lib, pkgs, ... }:
let
  helixUnwrapped = pkgs.helix;
  # Formatters to inject into $PATH
  pathPrefix = lib.makeBinPath [
    pkgs.mdformat
    pkgs.nixfmt
  ];

  # Prefix $PATH
  mainProgram = baseNameOf (lib.getExe helixUnwrapped);
  helixWrapped = pkgs.symlinkJoin {
    name = mainProgram;
    paths = [ helixUnwrapped ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/${mainProgram} --prefix PATH : ${pathPrefix}
    '';
  };
in
{
  programs.helix = {
    enable = true;
    defaultEditor = true;
    package = helixWrapped;
  };

  home.file = {
    ".config/helix/config.toml".source = ./config.toml;
    ".config/helix/languages.toml".source = ./languages.toml;
  };
}
