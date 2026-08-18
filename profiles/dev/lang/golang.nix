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
  options.profiles.dev.golang = {
    runtime = lib.mkEnableOption "Go runtime";
    tooling = lib.mkEnableOption "Go tooling";
  };

  config = lib.mkMerge [
    (lib.mkIf config.profiles.dev.golang.runtime {
      home-manager.users.${username}.home.packages = with pkgs; [
        go
      ];
    })

    (lib.mkIf config.profiles.dev.golang.tooling {
      home-manager.users.${username} = {
        home.packages = with pkgs; [
          gopls
        ];
        programs.helix.languages = {
          language = [
            {
              name = "go";
              language-servers = [ "gopls" ];
              formatter = {
                command = "gofmt";
                args = [
                  "-s"
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
