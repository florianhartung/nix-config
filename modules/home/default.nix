{ ... }:
{
  imports = [
    # Opinionated configurations that should be the default for everyone
    ./core-user.nix

    ./mutable-symlinks
    ./opinionated

    ./discord
    ./firefox
    ./fish.nix
    ./fonts.nix
    ./gde-stuff.nix
    ./helix
    ./home-manager-support.nix
    ./rustic.nix
    ./vscodium
    ./zellij
  ];
}
