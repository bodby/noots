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
        * { font-family: ${theme.fonts.monospace}; }

        .modules-left, .modules-right, .modules-center {
          border: 1px solid #${theme.palette.base01};
        }

        #temperature, #cpu, #battery, #memory, #network, #wireplumber, #mpd {
          color: #${theme.palette.base08};
        }

        #workspaces button { color: #${theme.palette.base09}; }
        #workspaces button:hover { color: #${theme.palette.base08}; }
        #workspaces button.active { color: #${theme.palette.base16}; }
        #clock.date, #clock.time { color: #${theme.palette.base16}; }
      '';

    settings = [{
      # width = 960;
      margin-left = 240;
      margin-right = 240;
      # https://github.com/hyprwm/hyprland-plugins/issues/280
      margin-top = 1;
      height = 48;
      position = "bottom";
      exclusive = true;
      layer = "top";
      spacing = 10;

      modules-left = [
        "clock#date"
        "cpu"
        "temperature"
        "memory"
      ];

      modules-center = [ "hyprland/workspaces" ];

      modules-right = [
        "mpd"
        "network"
        "battery"
        "wireplumber"
        "clock#time"
      ];

      cpu = {
        interval = 20;
        format = "{usage}%";
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
        interval = 20;
        format = "{used}Gi";
        tooltip = false;
      };

      "clock#date" = {
        interval = 2400;
        format = "{:%Y-%m-%d}";
        tooltip = false;
      };

      "clock#time" = {
        interval = 60;
        format = "{:%H:%M}";
        max-length = -1;
        tooltip = false;
      };

      battery = {
        interval = 20;
        format = "{time}-{capacity}%";
        format-time = "<span font_weight='bold' color='#${theme.palette.base16}'>{H}h {m}m</span> ";
        format-charging = "{time}+{capacity}%";
        tooltip = false;
      };

      wireplumber = {
        format = "{volume}%";
        max-volume = 60;
        scroll-step = 2;
        tooltip = false;
      };

      network = {
        interval = 240;
        # format = "{essid}";
        format = "";
        format-disconnected = "d/c";
        tooltip = false;
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons.default = "◦";
        format-icons.active = "◉";
        persistent-workspaces."*" = 5;
        tooltip = false;
      };

      mpd = {
        interval = 20;
        format = "{elapsedTime:%M:%S}/{totalTime:%M:%S}";
        format-disconnected = "down";
        format-stopped = "stopped";
        tooltip = false;
        on-click = "${pkgs.mpc}/bin/mpc toggle";
        on-click-right = "${pkgs.mpc}/bin/mpc next";
        on-scroll-up = "${pkgs.mpc}/bin/mpc seek +00:00:10";
        on-scroll-down = "${pkgs.mpc}/bin/mpc seek -00:00:10";
      };
    }];
  };
}
