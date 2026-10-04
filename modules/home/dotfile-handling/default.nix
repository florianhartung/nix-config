# Partially based on https://gist.github.com/piousdeer/b29c272eaeba398b864da6abf6cb5daa
{ config, lib, ... }:
let
  cfgBackupDirectoryForDotfileDiffs = config.backupDirectoryForDotfileDiffs;
in
{
  imports = [
    ./alacritty.nix
    ./zed-editor.nix
  ];

  options =
    let
      additionalOptionsForFileType = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            { ... }: {
              options.mutableAndBackupDiffs = lib.mkOption {
                description = ''
                  Whether to copy the file without the read-only attribute
                  instead of symlinking and backup the changes made to it in the
                  configured directory as diffs.
                '';
                default = false;
                type = lib.types.bool;
              };
            }
          )
        );
      };
    in
    {
      home.file = additionalOptionsForFileType;
      xdg.configFile = additionalOptionsForFileType;
      xdg.dataFile = additionalOptionsForFileType;

      backupDirectoryForDotfileDiffs = lib.mkOption {
        description = ''
          The directory to store the diffs of mutable dotfiles in.
        '';
        default = null;
      };
    };

  config =
    let
      # It's sufficient to read files from home.file, because `xdg.configFile`
      # and `xdg.dataFile` also create their files through it.
      allFiles = builtins.attrValues (lib.getAttrFromPath [ "home" "file" ] config);
      affectedFiles = builtins.filter (file: file.mutableAndBackupDiffs or false) allFiles;
    in
    {
      assertions = [
        {
          assertion = builtins.length affectedFiles > 0 -> cfgBackupDirectoryForDotfileDiffs != null;
          message = ''
            You have enabled `mutableAndBackupDiffs` for some file and have not
            set `backupDirectoryForDotfileDiffs` which is required.
          '';
        }
      ];

      home.activation =
        let
          # TODO: use three-way diff (diff3)
          # TODO: `|| true` in the script is bad. diff can exit with 0, 1 or 2
          # where only 2 is an actual error.
          generateAndStoreDiffsCommand = (
            file:
            let
              source = lib.escapeShellArg file.source;
              target = lib.escapeShellArg file.target;
              targetAbsolute = "${config.home.homeDirectory}/${target}";
              lastGeneration = "$oldGenPath/home-files/${target}";
              # Use the path as a filename for the patch
              patchFilename = lib.strings.replaceString "/" "_" target;
              # And append the current datetime to prevent collisions and append the extension
              diffsPath = "${cfgBackupDirectoryForDotfileDiffs}/${patchFilename}_$(date -d 'today' +'%Y%m%d%H%M%S').diff";
            in
            ''
              (
                verboseEcho "Generating patch between ${target} and ${source}"
                # Prefixing the diff part with `run` didn't work, so instead
                # generate the diff even during dry runs.
                cmp --silent -- ${targetAbsolute} ${source} ||
                  diff3 --merge --label='new config' --label='old config' --label='mutable changes' -- ${source} ${lastGeneration} ${target} |
                  diff -Naur --label='new config' --label='merged mutable changes' -- ${source} - > ${diffsPath} ||
                  true
              )
            ''
          );

          copyFileIntoPlaceCommand = (
            file:
            let
              source = lib.escapeShellArg file.source;
              target = lib.escapeShellArg file.target;
            in
            ''
              verboseEcho "${source} -> ${target}"
              run cp --remove-destination --no-preserve=mode ${source} ${target}
            ''
          );

        in
        {
          mutableFileGeneration = lib.hm.dag.entryAfter [ "linkGeneration" ] (
            lib.concatLines (
              [ "echo 'Copying mutable home files...'" ] ++ (map copyFileIntoPlaceCommand affectedFiles)
            )
          );

          # Even though we do not modify the system, put this after
          # `writeBoundary` just to be safe.
          mutableFileBackupDiffs = lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ] (
            lib.concatLines (
              [ "echo 'Generating backup diffs for mutable dotfiles...'" ]
              ++ (map generateAndStoreDiffsCommand affectedFiles)
              ++ [ "echo Done" ]
            )
          );
        };
    };
}
