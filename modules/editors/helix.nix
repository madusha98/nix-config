{ pkgs, lib, vars, ... }:
{
  home-manager.users.${vars.user} = {
    programs.helix = {
      enable = true;
      
      settings = {
        theme = lib.mkForce "dark_plus";
        
        editor = {
          line-number = "relative";
          mouse = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides.render = true;
          rulers = [ 80 ];
          soft-wrap.enable = true;
          auto-pairs = true;
          auto-completion = true;
          auto-format = true;
          auto-save = true;
          bufferline = "multiple";
          color-modes = true;
          true-color = true;
          undercurl = true;
          search = {
            smart-case = true;
            wrap-around = true;
          };
          statusline = {
            left = ["mode" "spinner" "file-name" "file-modification-indicator"];
            center = ["file-type"];
            right = ["diagnostics" "selections" "position" "file-encoding"];
          };
        };
        
        keys.normal = {
          space.e = ":open ~/.";
          space.q = ":quit";
          space.w = ":write";
          C-h = "jump_view_left";
          C-j = "jump_view_down";
          C-k = "jump_view_up";
          C-l = "jump_view_right";
        };
        
        keys.insert = {
          j.k = "normal_mode";
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter = {
              command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            };
          }
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "python";
            auto-format = true;
          }
          {
            name = "javascript";
            auto-format = true;
          }
          {
            name = "typescript";
            auto-format = true;
          }
        ];
      };
    };
  };
}