{
  pkgs,
  ...
}:
{
  home-manager.users.bodby.xdg.configFile."iamb/config.toml".source = (pkgs.formats.toml { }).generate "config.toml" {
    default_profile = "bodby";
    profiles.bodby.user_id = "@bodby:matrix.org";
    layout.style = "new";
    message_shortcode_display = false;
    read_receipt_display = true;
    read_receipt_send = false;
    user_gutter_width = 24;
  };
}
