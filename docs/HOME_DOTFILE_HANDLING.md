# Dotfile Handling in Home Manager Configurations

In the following I show the problem I faced with dotfile management and
some solutions for it. I also present the final solution I chose and its
implementation.

**TL;DR**: Generating dotfiles from Nix code is often advantageous but some
programs expect mutable dotfiles. Dotfile generation from Nix code, mutable
dotfiles and the prevention of data loss of changes are required.

## Motivation

I want my dotfiles to be generated from Nix code. That way I can have more
advanced generation strategies for multiple users (e.g. private and work).

However, some programs (VSCode, Zed, ...) try to modify their own dotfiles which
fails as they are read-only symlinks into the Nix store.

Therefore, I set three requirements for handling dotfiles:

1. NIX-GEN: Dotfiles must be generated from Nix code on every activation.
2. WRITEABLE: Dotfiles must be writeable.
3. NO-DATA-LOSS: When dotfiles are overwritten, all changes made to it since the
   last activation must be saved.

Together, NIX-GEN and NO-DATA-LOSS should result in a workflow where dotfiles
are always automatically generated from Nix, while allowing fast iteration
for configuration. When configuration is done, the changes made must be
re-integrated into the Nix config which acts as the single source of truth.

## Solutions

1. Copy all dotfiles from the Nix store to their target paths. Make dotfile
   directories such as `.config` Git repositories to keep track of changes.
   Home Manager could be configured to automatically commit everything prior
   to overwriting the existing dotfiles. Also, a `.gitignore` can be used as a
   whitelist to minimize the file tracking.
2. Similar to 1. except that the Git repository of the Nix configuration
   is reused to also keep track of previous mutable dotfiles. This can be
   implemented by adding a `dotfile-backups` directory to the Nix config and
   having Home Manager copy all dotfiles into it.
3. Improving on 2., one could store only the changes made to the dotfiles in a
   `dotfile-diff-backups` directory as patches. This allows the user to then use
   the patches as to-dos for reintegration into the Nix config.

I am going with solution 3.

## Implementation of Solution 3
