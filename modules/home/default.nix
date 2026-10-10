{ ... }:
{
  imports = [
    # Opinionated configurations that should be the default for everyone
    ./core-user.nix

    ./opinionated

    ./discord
    ./fish.nix
    ./fonts.nix
    ./gde-stuff.nix
    ./helix
    ./ov.nix
    ./rustic.nix
    ./vscodium
    ./zellij
  ];
}
