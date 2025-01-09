{
  # TODO: Haddock.
  home-manager.users.bodby.xdg.configFile."cabal/config".text = ''
    nix:                  True
    executable-dynamic:   False
    executable-stripping: True
    library-stripping:    True
    user-install:         False
    -- installdir: /home/bodby/.local/bin
    jobs:                 $ncpus
    cabal-version:        3.4

    build-summary:          /home/bodby/.cache/cabal/logs/build.log
    remote-repo-cache:      /home/bodby/.cache/cabal/packages
    remote-build-reporting: none

    init
      interactive:     True
      quiet:           False
      minimal:         True
      application-dir: app
      source-dir:      src

    install-dirs user
      prefix: /home/bodby/.cabal
    install-dirs global
      prefix: /home/bodby/.cabal
  '';
}
