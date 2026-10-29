{
  lib,
  config,
  pkgs-unstable,
  ...
}:
import ./mkEnableWithOpinionatedConfigModule.nix { inherit config lib; } [ "programs" "gram" ] {
  programs.gram = {
    package = pkgs-unstable.gram;
    keymaps = [
      {
        bindings = {
          ctrl-q = null;
        };
      }
      {
        context = "Editor && vim_mode == helix_normal";
        bindings = {
          "space q" = "editor::Rewrap";
        };
      }
      {
        context = "Workspace";
        bindings = {
          # keep-sorted start
          alt-h = [
            "workspace::IncreaseActiveDockSize"
            {
              "px" = 200;
            }
          ];
          alt-l = [
            "workspace::DecreaseActiveDockSize"
            { px = 200; }
          ];
          ctrl-alt-- = null;
          ctrl-g = "project_panel::ToggleFocus";
          # keep-sorted end
        };
      }
      {
        bindings = {
          ctrl-t = "terminal_panel::Toggle";
        };
      }
      {
        context = "vim_mode == literal";
        bindings = {
          ctrl-g = null;
        };
      }
      {
        context = "(VimControl && !menu)";
        bindings = {
          ctrl-g = null;
        };
      }
      {
        context = "(Editor && mode == full)";
        bindings = {
          ctrl-g = null;
        };
      }
      {
        context = "ContextEditor > Editor";
        bindings = {
          ctrl-g = null;
        };
      }
      {
        context = "Workspace";
        bindings = {
        };
      }
    ];

    settings = {
      # keep-sorted start
      auto_update = false;
      buffer_font_family = "JetBrains Mono";
      buffer_font_size = 13.0;
      buffer_font_weight = 400.0;
      buffer_line_height = "comfortable";
      cli_default_open_behavior = "existing_window";
      debugger = {
        button = false;
      };
      git = {
        branch_picker = {
          show_author_name = true;
        };
        blame = {
          show_avatar = false;
        };
        inline_blame = {
          enabled = true;
          padding = 8;
        };
        hunk_style = "staged_hollow";
      };
      git_panel = {
        dock = "left";
        button = false;
      };
      go_to_definition_fallback = "none";
      gutter = {
        line_numbers = true;
        runnables = false;
        breakpoints = false;
        min_line_number_digits = 4;
        folds = true;
      };
      helix_mode = true;
      icon_theme = "Material Icon Theme";
      inlay_hints = {
        enabled = true;
        show_other_hints = false;
        show_parameter_hints = true;
        show_value_hints = true;
        show_background = false;
      };
      inline_code_actions = true;
      load_direnv = "direct";
      outline_panel = {
        indent_guides = {
          show = "always";
        };
        dock = "left";
        button = true;
      };
      preferred_line_length = 100;
      project_panel = {
        dock = "left";
        file_icons = true;
        entry_spacing = "comfortable";
        button = true;
      };
      relative_line_numbers = "enabled";
      search = {
        button = false;
      };
      semantic_tokens = "combined";
      show_edit_predictions = false;
      show_wrap_guides = true;
      soft_wrap = "none";
      status_bar = {
        cursor_position_button = true;
        active_language_button = false;
      };
      tab_bar = {
        show = true;
        show_nav_history_buttons = false;
        show_tab_bar_buttons = false;
      };
      tabs = {
        file_icons = false; # TODO
        git_status = true; # TODO
        show_diagnostics = "off"; # TODO
      };
      terminal = {
        button = false;
        dock = "right";
        font_family = "JetBrains Mono";
        font_size = 13.0;
        font_weight = 300;
      };
      theme = "Duskfox";
      theme_overrides = {
        Duskfox = {
          # Backgrounds
          "editor.background" = "#191726";
          "editor.gutter.background" = "#191726";
          "elevated_surface.background" = "#191726";
          "surface.background" = "#191726";
          background = "#191726";
          "panel.background" = "#191726";
          "scrollbar.track.background" = "#191726";
          "terminal.background" = "#191726";

          syntax = {
            attribute = {
              color = "#D9B959";
            };
            comment = {
              color = "#6F7485";
              font_style = "italic";
            };
            "comment.doc" = {
              color = "#8B8793";
            };
            keyword = {
              color = "#EA5D6D";
            };
            # constant = {
            #   color: "#F1748B"
            # };
            # property = {
            #   color: "#5CCFAB"
            # };
            function = {
              color = "#9896E4";
            };
            hint = {
              font_style = "italic";
            };
          };
        };
      };
      title_bar = {
        show_sign_in = false;
        show_user_picture = false;
        show_onboarding_banner = false;
        show_project_items = true;
        show_branch_name = true;
      };
      toolbar = {
        breadcrumbs = true; # TODO
        quick_actions = false; # TODO
        selections_menu = true; # TODO
        agent_review = false;
        code_actions = true; # TODO
      };
      ui_font_family = "JetBrains Mono";
      ui_font_size = 13.0;
      use_system_prompts = true;
      wrap_guides = [ 100 ];
      # keep-sorted end
    };

  };
}
