{pkgs, ...}: {
  home.packages = [pkgs.jj-starship];

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      command_timeout = 200;

      # --- Character ---
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
        vimcmd_symbol = "[❮](bold green)";
        vimcmd_visual_symbol = "[❮](bold yellow)";
        vimcmd_replace_symbol = "[❮](bold purple)";
        vimcmd_replace_one_symbol = "[❮](bold purple)";
      };

      # --- Vi Mode Symbols ---

      # --- Cloud & Tools ---
      aws.symbol = "  ";
      buf.symbol = " ";
      c.symbol = " ";
      cmake.symbol = " ";
      conda.symbol = " ";
      crystal.symbol = " ";
      dart.symbol = " ";
      deno.symbol = " ";
      docker_context.symbol = " ";
      gcloud.symbol = "  ";
      golang.symbol = " ";
      gradle.symbol = " ";
      guix_shell.symbol = " ";
      hostname.ssh_symbol = " ";
      memory_usage.symbol = "󰍛 ";
      meson.symbol = "󰔷 ";
      nix_shell.symbol = " ";
      nodejs.symbol = " ";
      package.symbol = "󰏗 ";
      pixi.symbol = "󰏗 ";

      # --- Git / Version Control ---
      # jj-starship is a low-latency unified Git/Jujutsu module.
      # It replaces Starship's built-in Git branch/status modules so colocated
      # jj repos don't show duplicated VCS prompt segments.
      git_branch.disabled = true;
      git_status.disabled = true;
      git_commit.tag_symbol = "  ";
      fossil_branch.symbol = " ";
      hg_branch.symbol = " ";
      pijul_channel.symbol = " ";
      custom.jj = {
        when = "jj-starship detect";
        shell = ["jj-starship"];
        format = "$output ";
      };

      # --- Languages ---
      bun.symbol = " ";
      cpp.symbol = " ";
      elixir.symbol = " ";
      elm.symbol = " ";
      fennel.symbol = " ";
      haskell.symbol = " ";
      haxe.symbol = " ";
      java.symbol = " ";
      julia.symbol = " ";
      kotlin.symbol = " ";
      lua.symbol = " ";
      nim.symbol = "󰆥 ";
      ocaml.symbol = " ";
      perl.symbol = " ";
      php.symbol = " ";
      python.symbol = " ";
      rlang.symbol = "󰟔 ";
      ruby.symbol = " ";
      rust.symbol = "󱘗 ";
      scala.symbol = " ";
      swift.symbol = " ";
      zig.symbol = " ";

      # --- System ---
      directory.read_only = " 󰌾";

      # --- OS Symbols ---
      os.disabled = false;
      os.symbols = {
        Alpaquita = " ";
        Alpine = " ";
        AlmaLinux = " ";
        Amazon = " ";
        Android = " ";
        Arch = " ";
        Artix = " ";
        CachyOS = " ";
        CentOS = " ";
        Debian = " ";
        DragonFly = " ";
        Emscripten = " ";
        EndeavourOS = " ";
        Fedora = " ";
        FreeBSD = " ";
        Garuda = "󰛓 ";
        Gentoo = " ";
        HardenedBSD = "󰞌 ";
        Illumos = "󰈸 ";
        Kali = " ";
        Linux = " ";
        Mabox = " ";
        Macos = " ";
        Manjaro = " ";
        Mariner = " ";
        MidnightBSD = " ";
        Mint = " ";
        NetBSD = " ";
        NixOS = " ";
        Nobara = " ";
        OpenBSD = "󰈺 ";
        openSUSE = " ";
        OracleLinux = "󰌷 ";
        Pop = " ";
        Raspbian = " ";
        Redhat = " ";
        RedHatEnterprise = " ";
        RockyLinux = " ";
        Redox = "󰀘 ";
        Solus = "󰠳 ";
        SUSE = " ";
        Ubuntu = " ";
        Unknown = " ";
        Void = " ";
        Windows = "󰍲 ";
      };
    };
  };
}
