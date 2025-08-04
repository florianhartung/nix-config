final: prev:
let inherit (prev) lib;
in {
  rustic-rest-server = final.callPackage ./pkgs/rustic-rest-server.nix;
}
# lib.filesystem.packagesFromDirectoryRecursive {
#   callPackage = final.callPackage;
#   directory = ./pkgs;
# }
