{ config, lib, ... }:
let
  username = config.myconfig.username;
in
{
  home-manager.users.${username}.programs = {
    ssh =  {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*".addKeysToAgent = "yes";
    };

    bash = {
      initExtra = lib.mkAfter ''
        if [ -z "$SSH_AUTH_SOCK" ]; then
          eval $(ssh-agent -s) > /dev/null
        fi
      '';
 
    };
  };
}

