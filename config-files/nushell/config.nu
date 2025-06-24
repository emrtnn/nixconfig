# Nushell configuration file

$env.EDITOR = "hx"
$env.VISUAL = "hx"

# Settings
$env.config = {
	show_banner: false
	buffer_editor: "hx"
	highlight_resolved_externals: true
	edit_mode: "vi"
}

# Yazi cd into the dir when is closed
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

# Environment variables

$env.TRANSIENT_PROMPT_COMMAND = null
$env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent.socket"

# Startup programs
fastfetch
