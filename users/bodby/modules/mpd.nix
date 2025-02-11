{
  pkgs,
  ...
}:
{
  home-manager.users.bodby = {
    services.mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Sound Server"
        }
      '';
    };
    systemd.user.services.swaybg = {
      Unit = {
        Description = "Because MPD's config isn't enough";
        PartOf = [ "sound.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.mpc-init}/bin/mpc-init";
        KillMode = "mixed";
      };

      # FIXME: vvv
      Install.WantedBy = [ "default.target" ];
    };
  };
}
