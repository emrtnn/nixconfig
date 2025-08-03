# Nushell configuration file

# Settings

$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

$env.config = {
	show_banner: false
	buffer_editor: "nvim"
	highlight_resolved_externals: true
}

# Environment variables

$env.TRANSIENT_PROMPT_COMMAND = null
$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent.socket"

# Aliases

# Startup programs

sleep 0.1sec
fastfetch
