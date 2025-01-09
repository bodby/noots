{
  config,
  ...
}:
let
  cfg = config.modules.users.bodby.desktop;
in
{
  home-manager.users.bodby.programs.waybar = {
    enable = cfg.enable;
    style = ./style.css;
    systemd.enable = true;

    settings = [{
      width = 960;
      height = 48;
      position = "bottom";
      exclusive = true;
      layer = "top";
      spacing = 12;

      modules-left = [
        "cpu"
        "temperature"
        "memory"
      ];

      modules-center = [
        "clock#date"
        "clock#time"
      ];

      modules-right = [
        "wireplumber"
        "battery"
        "network"
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
        format = "{used} GiB";
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
        interval = 180;
        format = "-{capacity}%";
        format-charging = "+{capacity}%";
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
        format-disconnected = "down";
        tooltip = false;
      };
    }];
  };
}
