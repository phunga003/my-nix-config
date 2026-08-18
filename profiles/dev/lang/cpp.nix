{
  config,
  pkgs,
  lib,
  ...
}:
let
  username = config.myconfig.username;
  cfg = config.profiles.dev.cpp;
in
{
  options.profiles.dev.cpp = {
    runtime = lib.mkEnableOption "C++ runtime";
    tooling = lib.mkEnableOption "C++ tooling";
    godot = lib.mkEnableOption "Godot GDExtension C++ development";
  };
  config = lib.mkIf (cfg.runtime || cfg.tooling || cfg.godot) {
    home-manager.users.${username} = {
      home.packages =
        with pkgs;
        lib.optionals cfg.runtime [
          pkgconf
        ]
        ++ lib.optionals cfg.tooling [ clang-tools ]
        ++ lib.optionals cfg.godot [
          scons
          python3
          pkgs.pkgsCross.mingwW64.stdenv.cc
        ];

      programs.helix.languages = lib.mkIf cfg.tooling {
        language = [
          {
            name = "cpp";
            language-servers = [ "clangd" ];
          }
        ];
        language-server.clangd.command = "clangd";
      };
    };
  };
}
