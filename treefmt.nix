{ pkgs, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  # keep-sorted
  programs.keep-sorted = {
    enable = true;
    package = pkgs.writeShellScriptBin "keep-sorted" "${pkgs.keep-sorted}/bin/keep-sorted --default-options 'block=yes case=no numeric=yes remove_duplicates=no prefix_order=enable' $@";
  };
  programs.nixfmt.enable = true;
  programs.prettier = {
    enable = true;
    includes = [
      "*.md"
      "*.js"
    ];
  };
}
