{ inputs, pkgs, ... }:
{
	home.packages = with pkgs; [
		nil
		vscode-langservers-extracted
		hyprls
		marksman
		docker-compose-language-service
		dockerfile-language-server-nodejs
		tailwindcss-language-server
		yaml-language-server
    rust-analyzer
    ruff
    pyright
    gopls
    vtsls
    emmet-ls
    biome
    lua-language-server
	];
}
