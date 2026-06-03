{
  config,
  pkgs,
  lib,
  ...
}:
let
  username = config.myconfig.username;
in
{
  options.profiles.dev.haskell = {
    runtime = lib.mkEnableOption "Haskell runtime";
    tooling = lib.mkEnableOption "Haskell tooling";
  };

  config = lib.mkMerge [
    (lib.mkIf config.profiles.dev.haskell.runtime {
      home-manager.users.${username}.home.packages = with pkgs; [
        ghc
        cabal-install
      ];
    })

    (lib.mkIf config.profiles.dev.haskell.tooling {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          haskell-language-server
          ormolu
        ];
        programs.helix.languages = {
          language = [
            {
              name = "haskell";
              language-servers = [ "haskell-language-server" ];
              formatter = {
                command = "ormolu";
                args = [
                  "--stdin-input-file"
                  "."
                ];
              };
              auto-format = true;
            }
          ];
        };
      };
    })
  ];
}
