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
      width = 1920;
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
        format = "<span color='#936df3'>CPU</span> {usage}%";
        tooltip = false;
      };

      temperature = {
        interval = 20;
        format = "<span color='#936df3'>TEMP</span> {temperatureC}°C";
        critical-threshold = 65;
        format-critical = "<span color='#936df3'>BOILING</span> {temperatureC}°C";
        hwmon-path-abs = cfg.hwmonPath;
        input-filename = cfg.hwmonInputFile;
        tooltip = false;
      };

      memory = {
        interval = 20;
        format = "<span color='#936df3'>RAM</span> {used} GiB";
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
        format = "<span color='#7289fd'>BAT</span> {capacity}%";
        format-charging = "<span color='#7289fd'>CHARGING</span> {capacity}%";
        tooltip = false;
      };

      wireplumber = {
        format = "<span color='#7289fd'>VOL</span> {volume}%";
        max-volume = 60;
        scroll-step = 2;
        tooltip = false;
      };

      network = {
        interval = 240;
        format = "<span color='#7289fd'>NET</span> {essid}";
        format-disconnected = "<span color='#7289fd'>NET</span> down";
        tooltip = false;
      };
    }];
  };
}
