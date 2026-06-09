_: {
  programs.noctalia = {
    enable = true;
    systemd.enable = false;

    settings = {
      settingsVersion = 5;

      audio = {
        enable_overdrive = false;
        enable_sounds = false;
        notification_sound = "";
        sound_volume = 0.5;
        volume_change_sound = "";
      };

      backdrop = {
        blur_intensity = 0.5;
        enabled = false;
        tint_intensity = 0.30000001192092896;
      };

      bar = {
        order = ["widgets"];
        widgets = {
          auto_hide = false;
          background_opacity = 1.0;
          border = "outline";
          border_width = 0.0;
          capsule = false;
          capsule_fill = "surface_variant";
          capsule_opacity = 1.0;
          capsule_padding = 6.0;
          center = ["workspaces" "media"];
          contact_shadow = false;
          enabled = true;
          end = ["tray" "notifications" "spacer_5" "bluetooth" "volume" "spacer_4" "control-center" "session"];
          font_weight = 500;
          layer = "top";
          margin_edge = 10;
          margin_ends = 150;
          padding = 14;
          panel_overlap = 1;
          position = "top";
          radius = 0;
          radius_bottom_left = 18;
          radius_bottom_right = 18;
          radius_top_left = 18;
          radius_top_right = 18;
          reserve_space = true;
          scale = 1.0;
          shadow = true;
          start = ["date" "clock" "spacer_3" "group:g2"];
          thickness = 35;
          widget_spacing = 6;

          capsule_group = [
            {
              fill = "surface_variant";
              id = "g2";
              members = ["cpu" "temp" "ram"];
              opacity = 1.0;
              padding = 6.0;
            }
          ];
        };
      };

      battery = {
        warning_threshold = 20;
      };

      brightness = {
        enable_ddcutil = false;
        ignore_mmids = [];
      };

      calendar = {
        enabled = false;
        refresh_minutes = 15;
      };

      control_center = {
        sidebar = "compact";
        sidebar_section = "compact";
        shortcuts = [
          {type = "wifi";}
          {type = "bluetooth";}
          {type = "caffeine";}
          {type = "nightlight";}
          {type = "notification";}
          {type = "power_profile";}
        ];
      };

      desktop_widgets = {
        enabled = true;
        schema_version = 2;
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
      };

      dock = {
        active_monitor_only = false;
        active_opacity = 1.0;
        active_scale = 1.0;
        auto_hide = false;
        background_opacity = 0.87999999523162842;
        cross_axis_padding = 8;
        enabled = false;
        icon_size = 48;
        inactive_opacity = 0.85000002384185791;
        inactive_scale = 0.85000002384185791;
        item_spacing = 6;
        launcher_icon = "grid-dots";
        launcher_position = "none";
        magnification = true;
        magnification_scale = 1.4500000476837158;
        main_axis_padding = 16;
        margin_edge = 8;
        margin_ends = 0;
        monitors = [];
        pinned = [];
        position = "bottom";
        radius = 16;
        radius_bottom_left = 16;
        radius_bottom_right = 16;
        radius_top_left = 16;
        radius_top_right = 16;
        reserve_space = false;
        shadow = true;
        show_dots = false;
        show_instance_count = true;
        show_running = true;
      };

      hooks = {
        battery_charging = [];
        battery_discharging = [];
        battery_percentage_changed = [];
        battery_plugged = [];
        bluetooth_disabled = [];
        bluetooth_enabled = [];
        colors_changed = [];
        logging_out = [];
        power_profile_changed = [];
        rebooting = [];
        session_locked = [];
        session_unlocked = [];
        shutting_down = [];
        started = [];
        theme_mode_changed = [];
        wallpaper_changed = [];
        wifi_disabled = [];
        wifi_enabled = [];
      };

      idle = {
        behavior_order = ["lock" "screen-off" "lock-and-suspend"];
        pre_action_fade_seconds = 2.0;
        behavior = {
          lock = {
            action = "lock";
            command = "";
            enabled = true;
            resume_command = "";
            timeout = 600;
          };
          "lock-and-suspend" = {
            action = "lock_and_suspend";
            command = "";
            enabled = true;
            resume_command = "";
            timeout = 900;
          };
          "screen-off" = {
            action = "screen_off";
            command = "";
            enabled = true;
            resume_command = "";
            timeout = 660;
          };
        };
      };

      keybinds = {
        cancel = ["Escape"];
        down = ["Down"];
        left = ["Left"];
        right = ["Right"];
        up = ["Up"];
        validate = ["Return" "KP_Enter"];
      };

      location = {
        address = "Granada, Spain";
        auto_locate = false;
        sunrise = "";
        sunset = "";
      };

      lockscreen = {
        blur_intensity = 0.5;
        blurred_desktop = false;
        tint_intensity = 0.30000001192092896;
        wallpaper = "";
      };

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = ["lockscreen-login-box@DP-1"];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@DP-1" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 1280.0;
            cy = 1317.0;
            enabled = true;
            output = "DP-1";
            rotation = 0.0;
            type = "login_box";
            settings = {};
          };
        };
      };

      nightlight = {
        enabled = false;
        force = false;
        temperature_day = 6500;
        temperature_night = 4000;
      };

      notification = {
        allowed_urgencies = [];
        background_opacity = 0.97000002861022949;
        blacklist = [];
        blacklist_allow_critical = true;
        collapse_on_dismiss = true;
        enable_daemon = true;
        layer = "top";
        monitors = [];
        offset_x = 20;
        offset_y = 8;
        position = "bottom_right";
        scale = 1.0;
        show_actions = true;
        show_app_name = true;
      };

      osd = {
        background_opacity = 0.97000002861022949;
        monitors = [];
        offset_x = 20;
        offset_y = 8;
        orientation = "horizontal";
        position = "top_center";
        scale = 1.0;
        kinds = {
          bluetooth = true;
          brightness = true;
          caffeine = true;
          dnd = true;
          keyboard_layout = true;
          lock_keys = true;
          power_profile = true;
          volume = true;
          volume_input = true;
          volume_output = true;
          wifi = true;
        };
      };

      shell = {
        app_icon_colorize = false;
        clipboard_auto_paste = "auto";
        clipboard_confirm_clear_history = true;
        clipboard_enabled = true;
        clipboard_history_max_entries = 50;
        clipboard_image_action_command = "";
        corner_radius_scale = 1.0;
        date_format = "%A, %x";
        disable_mipmaps = false;
        font_family = "GeistMono Nerd Font Mono";
        lang = "en";
        launch_apps_as_systemd_services = true;
        middle_click_opens_widget_settings = true;
        niri_overview_type_to_launch_enabled = false;
        offline_mode = false;
        password_style = "default";
        polkit_agent = false;
        screen_time_enabled = false;
        settings_show_advanced = true;
        setup_wizard_enabled = true;
        shared_gl_context = true;
        show_location = true;
        telemetry_enabled = false;
        time_format = "{:%H:%M}";
        ui_scale = 1.0;

        animation = {
          enabled = true;
          speed = 1.0;
        };

        mpris = {
          blacklist = [];
        };

        panel = {
          borders = true;
          clipboard_placement = "centered";
          control_center_placement = "attached";
          launcher_categories = true;
          launcher_compact = false;
          launcher_placement = "centered";
          launcher_show_icons = true;
          open_near_click_clipboard = false;
          open_near_click_control_center = false;
          open_near_click_launcher = false;
          open_near_click_session = false;
          open_near_click_wallpaper = false;
          session_placement = "attached";
          shadow = true;
          transparency_mode = "solid";
          wallpaper_placement = "attached";
        };

        screen_corners = {
          enabled = false;
          size = 32;
        };

        screenshot = {
          copy_to_clipboard = true;
          directory = "";
          filename_pattern = "";
          freeze_screen = true;
          pipe_command = "";
          pipe_to_command = false;
          save_to_file = true;
        };

        session = {
          actions = [
            {
              action = "lock";
              command = "";
              enabled = true;
              glyph = "";
              label = "";
              shortcut = "1";
              variant = "default";
            }
            {
              action = "logout";
              command = "";
              enabled = true;
              glyph = "";
              label = "";
              shortcut = "2";
              variant = "default";
            }
            {
              action = "lock_and_suspend";
              command = "";
              enabled = true;
              glyph = "";
              label = "";
              shortcut = "3";
              variant = "default";
            }
            {
              action = "reboot";
              command = "";
              enabled = true;
              glyph = "";
              label = "";
              shortcut = "4";
              variant = "default";
            }
            {
              action = "shutdown";
              command = "";
              enabled = true;
              glyph = "";
              label = "";
              shortcut = "5";
              variant = "destructive";
            }
          ];
        };

        shadow = {
          alpha = 0.55000001192092896;
          direction = "down";
        };
      };

      system = {
        monitor = {
          cpu_poll_seconds = 2.0;
          cpu_temp_activity_threshold = 60.0;
          cpu_temp_critical_threshold = 85.0;
          cpu_usage_activity_threshold = 50.0;
          cpu_usage_critical_threshold = 90.0;
          disk_pct_activity_threshold = 80.0;
          disk_pct_critical_threshold = 95.0;
          disk_poll_seconds = 10.0;
          enabled = true;
          gpu_poll_seconds = 0.0;
          gpu_temp_activity_threshold = 60.0;
          gpu_temp_critical_threshold = 85.0;
          gpu_usage_activity_threshold = 50.0;
          gpu_usage_critical_threshold = 95.0;
          gpu_vram_activity_threshold = 50.0;
          gpu_vram_critical_threshold = 90.0;
          memory_poll_seconds = 2.0;
          net_rx_activity_threshold = 1.0;
          net_rx_critical_threshold = 50.0;
          net_tx_activity_threshold = 1.0;
          net_tx_critical_threshold = 50.0;
          network_poll_seconds = 3.0;
          ram_pct_activity_threshold = 60.0;
          ram_pct_critical_threshold = 90.0;
          swap_pct_activity_threshold = 20.0;
          swap_pct_critical_threshold = 80.0;
        };
      };

      theme = {
        builtin = "Gruvbox";
        community_palette = "Oxocarbon";
        custom_palette = "";
        mode = "dark";
        source = "builtin";
        wallpaper_scheme = "m3-content";
        templates = {
          builtin_ids = ["btop" "gtk3" "gtk4" "qt"];
          community_ids = ["pi-agent" "discord" "papirus-icons" "yazi"];
          enable_builtin_templates = true;
          enable_community_templates = true;
        };
      };

      wallpaper = {
        directory = "/home/impuremonad/Pictures/Wallpapers";
        directory_dark = "";
        directory_light = "";
        edge_smoothness = 0.30000001192092896;
        enabled = true;
        fill_color = "";
        fill_mode = "stretch";
        per_monitor_directories = false;
        transition = ["fade" "wipe" "disc" "stripes" "zoom" "honeycomb"];
        transition_duration = 1500.0;
        transition_on_startup = true;

        automation = {
          enabled = false;
          interval_seconds = 1800;
          order = "random";
          recursive = true;
        };
      };

      weather = {
        effects = true;
        enabled = true;
        refresh_minutes = 30;
        unit = "metric";
      };

      widget = {
        active_window = {
          icon_size = 14.0;
          max_length = 260.0;
          min_length = 80.0;
          title_scroll = "none";
          type = "active_window";
        };
        bongocat = {
          script = "scripts/bongocat.lua";
          type = "scripted";
        };
        cpu = {
          stat = "cpu_usage";
          type = "sysmon";
        };
        date = {
          color = "on_surface";
          font_weight = 700;
          format = "{:%d %b}";
          type = "clock";
        };
        input_volume = {
          device = "input";
          type = "volume";
        };
        keyboard_layout = {
          cycle_command = "";
          hide_when_single_layout = false;
          type = "keyboard_layout";
        };
        lock_keys = {
          display = "short";
          hide_when_off = false;
          show_caps_lock = true;
          show_num_lock = true;
          show_scroll_lock = false;
          type = "lock_keys";
        };
        media = {
          art_size = 16.0;
          hide_when_no_media = true;
          max_length = 220.0;
          min_length = 80.0;
          title_scroll = "none";
          type = "media";
        };
        network_rx = {
          stat = "net_rx";
          type = "sysmon";
        };
        network_tx = {
          stat = "net_tx";
          type = "sysmon";
        };
        output_volume = {
          device = "output";
          type = "volume";
        };
        ram = {
          stat = "ram_pct";
          type = "sysmon";
        };
        spacer = {
          type = "spacer";
        };
        spacer_2 = {
          type = "spacer";
        };
        spacer_3 = {
          type = "spacer";
        };
        spacer_4 = {
          type = "spacer";
        };
        spacer_5 = {
          type = "spacer";
        };
        temp = {
          stat = "cpu_temp";
          type = "sysmon";
        };
        workspaces = {
          hide_when_empty = true;
          type = "workspaces";
        };
      };
    };
  };
}
