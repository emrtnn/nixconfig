{pkgs, ...}: {
  programs.opencode = {
    enable = true;

    settings = {
      theme = "gruvbox";
      autoupdate = true;

      permission = {
        edit = "ask";
        bash = "ask";
        webfetch = "allow";
      };

      keybinds = {
        input_newline = "ctrl+n";
      };

      mcp = {
        zai-mcp-server = {
          type = "local";
          command = ["pnpx" "@z_ai/mcp-server@latest"];
          environment = {
            Z_AI_API_KEY = "env:{Z_AI_API_KEY}";
            Z_AI_MODE = "ZAI";
          };
          enabled = true;
        };

        web-search-prime = {
          type = "remote";
          url = "https://api.z.ai/api/mcp/web_search_prime/mcp";
          headers = {
            Authorization = "Bearer env:{Z_AI_API_KEY}";
          };
          enabled = true;
        };

        web-reader = {
          type = "remote";
          url = "https://api.z.ai/api/mcp/web_reader/mcp";
          headers = {
            Authorization = "Bearer env:{Z_AI_API_KEY}";
          };
          enabled = true;
        };
      };
    };
  };
}
