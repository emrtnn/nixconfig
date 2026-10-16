{pkgs, ...}: let
  c = import ../themes/caelus.nix;
  selected = {
    fg = c.bg;
    bg = c.orange;
    bold = true;
  };
  border = {fg = c.orange;};
in {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    # Native Caelus theme generated from home/themes/caelus.nix.
    theme = {
      app.overall = {
        inherit (c) fg;
        inherit (c) bg;
      };
      mgr = {
        cwd.fg = c.orange;
        find_keyword = {
          fg = c.magenta;
          bold = true;
          underline = true;
        };
        find_position = {
          fg = c.yellow;
          bold = true;
        };
        marker_copied = {
          fg = c.green;
          bg = c.green;
        };
        marker_cut = {
          fg = c.red;
          bg = c.red;
        };
        marker_marked = {
          fg = c.cyan;
          bg = c.cyan;
        };
        marker_selected = {
          fg = c.orange;
          bg = c.orange;
        };
        count_copied = {
          fg = c.bg;
          bg = c.green;
        };
        count_cut = {
          fg = c.bg;
          bg = c.red;
        };
        count_selected = {
          fg = c.bg;
          bg = c.orange;
        };
        border_style.fg = c.gray3;
        syntect_theme = "${import ../themes/caelus-tmtheme.nix {inherit pkgs;}}";
      };
      tabs = {
        active = selected;
        inactive = {
          fg = c.gray9;
          bg = c.gray1;
        };
      };
      mode = {
        normal_main = selected;
        normal_alt = {
          fg = c.orange;
          bg = c.gray1;
        };
        select_main = {
          fg = c.bg;
          bg = c.green;
          bold = true;
        };
        select_alt = {
          fg = c.green;
          bg = c.gray1;
        };
        unset_main = {
          fg = c.bg;
          bg = c.magenta;
          bold = true;
        };
        unset_alt = {
          fg = c.magenta;
          bg = c.gray1;
        };
      };
      indicator = {
        parent = {
          inherit (c) fg;
          bg = c.gray2;
        };
        current = {
          inherit (c) fg;
          bg = c.gray2;
          bold = true;
        };
        preview = {
          fg = c.orange;
          underline = true;
        };
      };
      status = {
        overall = {
          fg = c.gray9;
          bg = c.gray1;
        };
        perm_sep.fg = c.gray6;
        perm_type.fg = c.blue;
        perm_read.fg = c.yellow;
        perm_write.fg = c.red;
        perm_exec.fg = c.green;
        progress_label = {
          inherit (c) fg;
          bold = true;
        };
        progress_normal = {
          fg = c.orange;
          bg = c.gray2;
        };
        progress_error = {
          fg = c.red;
          bg = c.gray2;
        };
      };
      which = {
        inherit border;
        cand.fg = c.cyan;
        rest.fg = c.gray6;
        desc.fg = c.gray9;
        separator_style.fg = c.gray3;
      };
      confirm = {
        inherit border;
        title.fg = c.orange;
        btn_yes = selected;
        btn_no = {
          fg = c.gray9;
          bg = c.gray1;
        };
      };
      spot = {
        inherit border;
        title.fg = c.orange;
        tbl_col.fg = c.cyan;
        tbl_cell = selected;
      };
      notify = {
        title_info.fg = c.green;
        title_warn.fg = c.yellow;
        title_error.fg = c.red;
      };
      pick = {
        inherit border;
        active = selected;
        inactive.fg = c.gray9;
      };
      input = {
        inherit border;
        title.fg = c.orange;
        value.fg = c.fg;
        inherit selected;
      };
      cmp = {
        inherit border;
        active = selected;
        inactive.fg = c.gray9;
      };
      tasks = {
        inherit border;
        title.fg = c.orange;
        hovered = selected;
      };
      help = {
        inherit border;
        chord.fg = c.cyan;
        action.fg = c.gray9;
        hovered = selected;
      };
      filetype.rules = [
        {
          mime = "**/image/*";
          fg = c.yellow;
        }
        {
          mime = "**/{audio,video}/*";
          fg = c.magenta;
        }
        {
          mime = "**/application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
          fg = c.red;
        }
        {
          mime = "**/application/{pdf,doc,rtf}";
          fg = c.cyan;
        }
        {
          mime = "vfs/{absent,stale}";
          fg = c.gray6;
        }
        {
          url = "*";
          is = "orphan";
          fg = c.bg;
          bg = c.red;
        }
        {
          url = "*";
          is = "exec";
          fg = c.green;
        }
        {
          url = "*";
          is = "dummy";
          fg = c.bg;
          bg = c.red;
        }
        {
          url = "*/";
          is = "dummy";
          fg = c.bg;
          bg = c.red;
        }
        {
          url = "*/";
          fg = c.orange;
          bold = true;
        }
        {
          url = "*";
          fg = c.gray9;
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
