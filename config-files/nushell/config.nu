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

# Git
alias ga = git add
alias gc = git commit
alias gco = git checkout
alias gcp = git cherry-pick
alias gdiff = git diff
alias gl = git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
alias gs = git status
alias gt = git tag

# Jujutsu
alias jd = jj desc
alias jf = jj git fetch
alias jn = jj new
alias jp = jj git push
alias js = jj st

# Startup programs

sleep 0.1sec
fastfetch
