# Nushell configuration file

# Settings

$env.EDITOR = "hx"
$env.VISUAL = "hx"

$env.config = {
	show_banner: false
	buffer_editor: "hx"
	highlight_resolved_externals: true
}

# Environment variables

$env.TRANSIENT_PROMPT_COMMAND = null
$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent.socket"

# Aliases

# Startup programs

sleep 0.1sec
fastfetch
