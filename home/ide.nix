{
  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_macchiato";
        editor = {
          lsp.display-messages = true;
          color-modes = true;
          inline-diagnostics = {
            cursor-line = "warning";
            other-lines = "error";
          };
          indent-guides = {
            render = true;
            character = "│";
            skip-levels = 1;
          };
        };
      };
    };
  };
}
