{
  lib,
  fetchurl,
  stdenv,
}:

# https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/generated-firefox-addons.nix
# TODO: How does rycee update these? I have never touched CI before.
stdenv.mkDerivation (finalAttrs: {
  pname = "vimium";
  version = "2.1.2";
  addonId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";

  src = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4259790/vimium_ff-2.1.2.xpi";
    sha256 = "3b9d43ee277ff374e3b1153f97dc20cb06e654116a833674c79b43b8887820e1";
  };

  preferLocalBuild = true;
  allowSubstitutes = true;

  passthru = { inherit (finalAttrs) addonId; };

  # FIXME: Add build hooks if they exist.
  buildCommand = /* bash */ ''
    # Why is this weird hash hard-coded?? What does it even do???
    dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
    install -D -m644 "$src" "$dst/${finalAttrs.addonId}.xpi"
  '';

  mozPermissions = [
    "tabs"
    "bookmarks"
    "history"
    "storage"
    "sessions"
    "notifications"
    "scripting"
    "webNavigation"
    "clipboardRead"
    "clipboardWrite"
    "<all_urls>"
    "file:///"
    "file:///*/"
  ];

  meta = {
    homepage = "https://github.com/philc/vimium";
    description = "The Hacker's Browser";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
