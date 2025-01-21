{
  lib,
  fetchurl,
  stdenv,
}:

# https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/generated-firefox-addons.nix
# TODO: How does rycee update these? I have never touched CI before.
stdenv.mkDerivation (finalAttrs: {
  pname = "ublock-origin";
  version = "1.62.0";
  addonId = "uBlock0@raymondhill.net";

  src = fetchurl {
    url = "https://addons.mozilla.org/firefox/downloads/file/4412673/ublock_origin-1.62.0.xpi";
    sha256 = "8a9e02aa838c302fb14e2b5bc88a6036d36358aadd6f95168a145af2018ef1a3";
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
    "alarms"
    "dns"
    "menus"
    "privacy"
    "storage"
    "tabs"
    "unlimitedStorage"
    "webNavigation"
    "webRequest"
    "webRequestBlocking"
    "<all_urls>"
    "http://*/*"
    "https://*/*"
    "file://*/*"
    "https://easylist.to/*"
    "https://*.fanboy.co.nz/*"
    "https://filterlists.com/*"
    "https://forums.lanik.us/*"
    "https://github.com/*"
    "https://*.github.io/*"
    "https://github.com/uBlockOrigin/*"
    "https://ublockorigin.github.io/*"
    "https://*.reddit.com/r/uBlockOrigin/*"
  ];

  meta = {
    homepage = "https://github.com/gorhill/uBlock";
    description = "An efficient blocker for Chromium and Firefox";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
})
