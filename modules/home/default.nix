{ ... }:
{
  imports = [
    ./alacritty.nix
    ./base.nix # todo split up and make a base preset
    ./common # todo split this into separate modules
    ./discord
    ./firefox
    ./fonts.nix
    ./gde-stuff.nix
    ./mutable-symlinks.nix
    ./rustic.nix
    ./vscodium
    ./zed
  ];
}
