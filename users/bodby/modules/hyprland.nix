{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.users.bodby.desktop;
  dirs = config.home-manager.users.bodby.xdg.userDirs;
in
{
  home-manager.users.bodby.wayland.windowManager.hyprland = {
    enable = cfg.enable;
    xwayland.enable = cfg.enable;
    plugins = with pkgs.hyprlandPlugins; [
      hyprscroller
      borders-plus-plus
    ];

    settings = {
      monitor = [
        "desc:Samsung Electric Company LC32G7xT HNATC00129, 2560x1440@239.96Hz, 0x0, 1"
        "desc:VXN VisN236HUZ15 0x199DA69F, preferred, 0x0, ${
          lib.strings.floatToString cfg.hyprland.scale
        }"
        ", preferred, auto, 1"
      ];

      general = {
        layout = "scroller";
        no_focus_fallback = false;
        gaps_in = (4 + cfg.hyprland.border.spacing);
        gaps_out = (24 + cfg.hyprland.border.spacing);
        border_size = -2;
      };

      decoration = {
        rounding = cfg.hyprland.border.radius;
        active_opacity = 1.0;
        inactive_opacity = 0.85;

        shadow.enabled = false;
        blur = {
          enabled = true;
          size = 16;
          passes = 3;
          noise = 0.0;
          contrast = 1.0;
          brightness = 1.0;
          ignore_opacity = true;
          vibrancy = 2.0;
          special = false;
          xray = true;
          popups = false;
        };

        # layerrule = [
        #   "blur, waybar"
        #   "ignorezero, waybar"
        # ];
      };

      plugin = {
        scroller = {
          column_default_width = "twothirds";
          focus_wrap = false;
          center_row_if_space_available = true;
          column_widths = "onethird onehalf twothirds one";
        };
        borders-plus-plus = {
          add_borders = 2;
          "col.border_1" = "rgba(efefff25)";
          "col.border_2" = "rgba(00000060)";
          border_size_1 = 1;
          border_size_2 = 1;
          natural_rounding = true;
        };
      };

      "$mod" = "SUPER";

      "$grimscr" = "${pkgs.grim}/bin/grim -t png ${dirs.pictures}/screenshots/$(date -dnow +%Y-%m-%d_%H-%M-%S).png";
      "$grimsec" = "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" -t png ${dirs.pictures}/screenshots/$(date -dnow +%Y-%m-%d_%H-%M-%S).png";

      input = {
        kb_layout = "us";
        kb_options = "grp:caps_switch";
        repeat_rate = 30;
        repeat_delay = 250;
        sensitivity = cfg.hyprland.sensitivity;
        accel_profile = "flat";
        follow_mouse = 2;

        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.9;
          tap-to-click = true;
          clickfinger_behavior = true;
        };
      };

      gestures.workspace_swipe = false;
      gestures.workspace_swipe_touch = false;

      cursor.hide_on_key_press = true;
      cursor.no_warps = true;
      cursor.no_hardware_cursors = lib.mkIf (builtins.elem "nvidia" (config.services.xserver.videoDrivers)) true;

      bind = [
        "$mod, Q, exec, foot"
        "$mod, V, exec, neovide"
        "$mod, E, exec, librewolf"
        "$mod, C, killactive"
        "$mod SHIFT, M, exit"
        # 61 is forward slash. You can get this using either 'wev' or 'xev'.
        "$mod, code:61, exec, $grimsec"
        "$mod SHIFT, code:61, exec, $grimscr"

        "$mod, T, togglefloating"
        "$mod, F, fullscreen, 1"
        "$mod SHIFT, F, fullscreen, 0"
        "$mod, S, pin"

        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, J, movewindow, d"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, L, movewindow, r"

        "$mod, G, scroller:movefocus, end"
        "$mod, B, scroller:movefocus, begin"
        "$mod, R, scroller:cyclewidth, next"
        "$mod SHIFT, R, scroller:cycleheight, next"

        "$mod SHIFT, C, scroller:alignwindow, c"
        "$mod, P, scroller:pin"
        "$mod, tab, scroller:toggleoverview"

        "$mod, I, scroller:admitwindow"
        "$mod, O, scroller:expelwindow"

        "$mod, U, workspace, e-1"
        "$mod, D, workspace, e+1"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
      ];

      # Move floating windows.
      binde = [
        "$mod, left, moveactive, -16 0"
        "$mod, right, moveactive, 16 0"
        "$mod, up, moveactive, 0 -16"
        "$mod, down, moveactive, 0 16"

        "$mod SHIFT, left, resizeactive, -16 0"
        "$mod SHIFT, right, resizeactive, 16 0"
        "$mod SHIFT, up, resizeactive, 0 -16"
        "$mod SHIFT, down, resizeactive, 0 16"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
      ];

      # exec-once = "swaybg -m fill -i ${dirs.pictures}/wallpapers/house.jpg";

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "rounding 0, class:^(steam)$"
        "noshadow on, class:^(steam)$"
        "noblur, floating:1"
        "opacity 1.0 override, floating:1"
        "workspace 4 silent, class:^(steam)$"
        "workspace 3 silent, class:^(WebCord)$"
      ];

      animations = {
        enabled = true;
        bezier = [
          "snappy, 0.0, 1.0, 0.0, 1.0"
          "linear, 0.0, 0.0, 0.0, 1.0"
        ];
        animation = [
          "windowsIn, 1, 4, snappy, popin 50%"
          "windowsOut, 1, 4, snappy, popin 50%"
          "windowsMove, 1, 4, snappy"
          "fade, 1, 1, linear"
          "workspaces, 1, 4, snappy, slidefadevert 10%"
          "specialWorkspace, 1, 4, snappy, slidevert"
        ];
      };

      misc = {
        background_color = "rgb(080808)";
        animate_manual_resizes = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        enable_swallow = true;
        swallow_regex = "^(foot)$";
        middle_click_paste = false;
        disable_hyprland_qtutils_check = true;
        vfr = true;
      };

      env = [
        "XCURSOR_THEME,Bibata-Modern-Classic"
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE,24"
        "MOZ_USE_XINPUT2,1"
      ]
      ++ lib.optionals (builtins.elem "nvidia" config.services.xserver.videoDrivers) [
        "LIBVA_DRIVER_NAME,nvidia"
        # "XDG_SESSION_TYPE,wayland"
        # "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
      ];

      ecosystem.no_update_news = true;
    };
  };
}
