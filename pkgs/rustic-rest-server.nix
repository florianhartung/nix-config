{ lib, fetchFromGithub, rustPlatform, }:

rustPlatform.buildRustPackage rec {
  pname = "rustic_server";
  version = "0.4.4";

  src = fetchFromGithub {
    owner = "rustic-rs";
    repo = "rustic_server";
    tag = "v${version}";
    hash = lib.fakeHash;
  };

  cargoHash = lib.fakeHash;

  # nativeBuildInputs = [ installShellFiles ]; # no cli -> remove?

  # passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/rustic-rs/rustic_server";
    changelog =
      "https://github.com/rustic-rs/rustic_server/blob/${src.rev}/CHANGELOG.md";
    description = "A REST server built in rust for use with rustic/restic";
    mainProgram = "restic_server";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = [ lib.licenses.agpl3Only ];
    maintainers = [ ];
  };
}
