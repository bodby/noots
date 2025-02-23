{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.users.bodby.desktop;
  theme = import ../theme.nix { inherit lib pkgs; };
in
{
  home-manager.users.bodby.programs.waybar = {
    enable = cfg.enable;
    systemd.enable = true;

    style = (builtins.readFile ./style.css)
      + /* css */ ''
        * { font-family: ${theme.fonts.sans}, ${theme.fonts.monospace' + " Propo"}; }
      '';

    settings = [{
      # https://github.com/hyprwm/hyprland-plugins/issues/280
      # margin-top = 1;
      height = 48;
      position = "bottom";
      exclusive = true;
      layer = "top";
      spacing = 12;

      modules-left = [
        "group/hyprland"
        "custom/separator"
        "group/audio"
      ];

      modules-center = [ "clock" ];

      modules-right = [
        "network"
        "battery"
        "group/processor"
        "memory"
      ];

      "custom/separator" = {
        format = "│";
        tooltip = false;
      };

      "group/hyprland" = {
        orientation = "vertical";
        modules = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
      };

      "group/audio" = {
        orientation = "horizontal";
        modules = [
          "wireplumber"
          "mpd"
        ];
      };

      "group/processor" = {
        orientation = "horizontal";
        modules = [
          "cpu"
          "temperature"
        ];
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "Misc";
          "2" = "Work";
          "3" = "Social";
          "4" = "Games";
          "5" = "Extra";
        };
        active-only = true;
        tooltip = false;
      };

      "hyprland/window" = {
        format = "{class}";
        rewrite = {
          "org.pwmt.zathura" = "Zathura";

          "librewolf" = "LibreWolf";
          "neovide" = "Neovide";
          "steam" = "Steam";
          "foot" = "Foot";

          "" = "Desktop";
        };
        tooltip = false;
      };

      wireplumber = {
        format = "<span alpha='25%'>  </span>{volume}% ";
        format-muted = "<span alpha='25%'>  </span>{volume}% ";
        max-volume = 60;
        scroll-step = 2;
        on-click = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle";
        tooltip = false;
      };

      mpd = {
        format = "{elapsedTime:%M:%S}/{totalTime:%M:%S}";
        format-disconnected = "";
        format-stopped = "--:--/--:--";

        on-click = "${pkgs.mpc}/bin/mpc toggle";
        on-click-right = "${pkgs.mpc}/bin/mpc next";
        on-scroll-up = "${pkgs.mpc}/bin/mpc seek +00:00:10";
        on-scroll-down = "${pkgs.mpc}/bin/mpc seek -00:00:10";

        interval = 20;
        tooltip = false;
      };

      clock = {
        interval = 60;
        format = "{:%A %Y-%m-%d, %H:%M}";
        max-length = -1;
        tooltip = false;
      };

      network = {
        format = "<span alpha='25%'>{icon}</span> {essid}";
        format-icons = [ "󰤟  " "󰤢  " "󰤥  " "󰤨  " ];
        format-ethernet = "<span alpha='25%'></span>";
        format-disconnected = "<span alpha='25%'>󰤫</span>";
        interval = 240;
        tooltip = false;
      };

      battery = {
        format = "<span alpha='25%'>{icon}</span> {capacity}% {time}";
        format-icons = [ "󰁺 " "󰁻 " "󰁼 " "󰁽 " "󰁾 " "󰁿 " "󰂀 " "󰂁 " "󰂂 " "󰁹 " ];
        format-charging = "<span alpha='25%'>󰂄 </span> {capacity}% <span alpha='25%'>{time}</span>";
        format-time = "{H}:{m}";
        interval = 20;
        tooltip = false;
      };

      cpu = {
        format = "<span alpha='25%'>  </span> {usage}% ";
        interval = 20;
        tooltip = false;
      };

      temperature = {
        interval = 20;
        format = "{temperatureC}°C";
        # critical-threshold = 65;
        # format-critical = "{temperatureC}°C";
        hwmon-path = cfg.waybar.cpuTemp;
        tooltip = false;
      };

      memory = {
        format = "<span alpha='25%'>  </span> {used}GiB";
        interval = 20;
        tooltip = false;
      };
    }];
  };
}
