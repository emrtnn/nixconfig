{pkgs, ...}: let
  c = import ../themes/oxocarbon.nix;
  selected = {
    fg = c.base00;
    bg = c.base09;
    bold = true;
  };
  border = {fg = c.base09;};
in {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    # No maintained Oxocarbon flavor was found; keep this native theme local.
    theme = {
      app.overall = {
        fg = c.base05;
        bg = c.base00;
      };
      mgr = {
        cwd.fg = c.base08;
        find_keyword = {
          fg = c.base0C;
          bold = true;
          underline = true;
        };
        find_position = {
          fg = c.base0E;
          bold = true;
        };
        marker_copied = {
          fg = c.base0D;
          bg = c.base0D;
        };
        marker_cut = {
          fg = c.base0A;
          bg = c.base0A;
        };
        marker_marked = {
          fg = c.base08;
          bg = c.base08;
        };
        marker_selected = {
          fg = c.base09;
          bg = c.base09;
        };
        count_copied = {
          fg = c.base00;
          bg = c.base0D;
        };
        count_cut = {
          fg = c.base00;
          bg = c.base0A;
        };
        count_selected = {
          fg = c.base00;
          bg = c.base09;
        };
        border_style.fg = c.base03;
        syntect_theme = "${import ../themes/oxocarbon-tmtheme.nix {inherit pkgs;}}";
      };
      tabs = {
        active = selected;
        inactive = {
          fg = c.base04;
          bg = c.base01;
        };
      };
      mode = {
        normal_main = selected;
        normal_alt = {
          fg = c.base09;
          bg = c.base01;
        };
        select_main = {
          fg = c.base00;
          bg = c.base0D;
          bold = true;
        };
        select_alt = {
          fg = c.base0D;
          bg = c.base01;
        };
        unset_main = {
          fg = c.base00;
          bg = c.base0C;
          bold = true;
        };
        unset_alt = {
          fg = c.base0C;
          bg = c.base01;
        };
      };
      indicator = {
        parent = {
          fg = c.base05;
          bg = c.base02;
        };
        current = {
          fg = c.base05;
          bg = c.base02;
          bold = true;
        };
        preview = {
          fg = c.base09;
          underline = true;
        };
      };
      status = {
        overall = {
          fg = c.base04;
          bg = c.base01;
        };
        perm_sep.fg = c.muted;
        perm_type.fg = c.base0E;
        perm_read.fg = c.base0F;
        perm_write.fg = c.base0A;
        perm_exec.fg = c.base0D;
        progress_label = {
          fg = c.base05;
          bold = true;
        };
        progress_normal = {
          fg = c.base09;
          bg = c.base02;
        };
        progress_error = {
          fg = c.base0A;
          bg = c.base02;
        };
      };
      which = {
        inherit border;
        cand.fg = c.base08;
        rest.fg = c.muted;
        desc.fg = c.base04;
        separator_style.fg = c.base03;
      };
      confirm = {
        inherit border;
        title.fg = c.base09;
        btn_yes = selected;
        btn_no = {
          fg = c.base04;
          bg = c.base01;
        };
      };
      spot = {
        inherit border;
        title.fg = c.base09;
        tbl_col.fg = c.base08;
        tbl_cell = selected;
      };
      notify = {
        title_info.fg = c.base0D;
        title_warn.fg = c.base0F;
        title_error.fg = c.base0A;
      };
      pick = {
        inherit border;
        active = selected;
        inactive.fg = c.base04;
      };
      input = {
        inherit border;
        title.fg = c.base09;
        value.fg = c.base05;
        selected = selected;
      };
      cmp = {
        inherit border;
        active = selected;
        inactive.fg = c.base04;
      };
      tasks = {
        inherit border;
        title.fg = c.base09;
        hovered = selected;
      };
      help = {
        inherit border;
        chord.fg = c.base08;
        action.fg = c.base04;
        hovered = selected;
      };
      filetype.rules = [
        {
          mime = "**/image/*";
          fg = c.base0E;
        }
        {
          mime = "**/{audio,video}/*";
          fg = c.base0C;
        }
        {
          mime = "**/application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
          fg = c.base0A;
        }
        {
          mime = "**/application/{pdf,doc,rtf}";
          fg = c.base08;
        }
        {
          mime = "vfs/{absent,stale}";
          fg = c.muted;
        }
        {
          url = "*";
          is = "orphan";
          fg = c.base00;
          bg = c.base0A;
        }
        {
          url = "*";
          is = "exec";
          fg = c.base0D;
        }
        {
          url = "*";
          is = "dummy";
          fg = c.base00;
          bg = c.base0A;
        }
        {
          url = "*/";
          is = "dummy";
          fg = c.base00;
          bg = c.base0A;
        }
        {
          url = "*/";
          fg = c.base09;
        }
        {
          url = "*";
          fg = c.base04;
        }
      ];
    };

    settings = {
      mgr = {linemode = "size";};
    };

    plugins = {
      inherit (pkgs.yaziPlugins) full-border;
    };
  };
}
