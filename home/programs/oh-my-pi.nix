{inputs, ...}: {
  imports = [inputs.oh-my-pi.homeManagerModules.default];

  programs.omp = {
    enable = true;
    settings = {
      startup.quiet = true;
      setupVersion = 2;
      theme.dark = "dark-gruvbox";
      symbolPreset = "unicode";
      defaultThinkingLevel = "high";
      modelRoles = {
        default = "openai-codex/gpt-6-astra:medium";
        plan = "openai-codex/gpt-6-astra:max";
        smol = "openai-codex/gpt-6-luna:high";
        slow = "openai-codex/gpt-6-astra:high";
        task = "openai-codex/gpt-6-astra:high";
      };
      edit.mode = "hashline";
    };
  };
}
