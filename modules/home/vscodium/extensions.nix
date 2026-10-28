pkgs:
with pkgs.vscode-extensions;
[

  # Languages
  tamasfe.even-better-toml # toml
  ms-toolsai.jupyter # jupyter notebooks
  mathiasfrohlich.kotlin # kotlin
  jnoortheen.nix-ide # nix
  ms-python.python # python
  rust-lang.rust-analyzer # rust
  myriad-dreamin.tinymist # typst
  ecmel.vscode-html-css # html & css
  bradlc.vscode-tailwindcss # tailwindcss
  redhat.vscode-yaml # yaml
  valentjn.vscode-ltex # grammar checker for latex (might work for Typst aswell)
  leanprover.lean4 # Lean

  # Themes
  github.github-vscode-theme

  # Keybindings
  k--kato.intellij-idea-keybindings
  vscodevim.vim

  # Misc
  streetsidesoftware.code-spell-checker # Spell checking
  fill-labs.dependi # Dependency management for Rust, etc.
  mkhl.direnv # Direnv for Nix shells
  tomoki1207.pdf # PDF Viewer

]
++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  {
    name = "vscode-glsllint";
    publisher = "dtoplak";
    version = "1.9.0";
    sha256 = "sha256-Ic5yCR9CIaYylw0wPSL7lgSk+2f2O/pYkWKGKJNwm0g=";
  }
  {
    name = "vscode-wasm";
    publisher = "dtsvet";
    version = "1.4.1";
    sha256 = "sha256-zs7E3pxf4P8kb3J+5zLoAO2dvTeepuCuBJi5s354k0I=";
  }
  {
    name = "wgsl";
    publisher = "polymeilex";
    version = "0.1.17";
    sha256 = "sha256-vGqvVrr3wNG6HOJxOnJEohdrzlBYspysTLQvWuP0QIw=";
  }
  {
    name = "shader";
    publisher = "slevesque";
    version = "1.1.5";
    sha256 = "sha256-Pf37FeQMNlv74f7LMz9+CKscF6UjTZ7ZpcaZFKtX2ZM=";
  }
  {
    name = "wit-idl";
    publisher = "bytecodealliance";
    version = "0.3.9";
    sha256 = "sha256-FsE/oop7X4lhotbt0TbNyzeUvy+IGK3MXVorZVux8qk=";
  }
  # {
  #   name = "vscode-sqlfluff";
  #   publisher = "dorzey";
  #   version = "3.3.1";
  #   sha256 = "sha256-oRxITH6PWTvKvpyTwGDzEFJ4Hhjt5bP7FAm8moN5Jo8=";
  # }
  # {
  #   name = "vscode-openapi";
  #   publisher = "42crunch";
  #   version = "4.31.0";
  #   sha256 = "sha256-ZS47eAKQBHB2ijNlMu1sVN/3U3vT7E7AMdC/9HN4uCg=";
  # }
]
