#!/usr/bin/env bash
# Turn pass/browserpass-style URL globs (e.g. "*amazon.es/*") into plain URLs
# ("https://amazon.es") that KeePassXC-Browser can match. Subdomains such as
# www.amazon.es still match, because KeePassXC matches subdomains by itself.
#
#   bash scripts/fix-urls.sh           # dry run: only shows what would change
#   bash scripts/fix-urls.sh --apply   # really edit the entries
#
# Close KeePassXC first so it doesn't edit the file at the same time.
set -euo pipefail

DB=${DB:-$HOME/Passwords/Passwords.kdbx}
KEY=${KEY:-$HOME/.local/share/keepassxc/Passwords.keyx}
apply=${1:-}

read -rsp "Master password: " pw
echo

# Run a keepassxc-cli command on the database, feeding the password on stdin.
kc() { printf '%s\n' "$pw" | keepassxc-cli "$1" -q -k "$KEY" "$DB" "${@:2}"; }

kc ls -R -f | grep -v '/$' | while IFS= read -r entry; do
  url=$(kc show -a URL "$entry")
  [[ "$url" == *'*'* ]] || continue # only entries whose URL has a wildcard

  host=${url//\*/}    # drop every *          "*amazon.es/*" -> "amazon.es/"
  host=${host#*://}   # drop a scheme, if any
  host=${host%%/*}    # drop the path         "amazon.es/"   -> "amazon.es"
  host=${host#.}      # drop a leading dot    ".google.com"  -> "google.com"
  new="https://$host"

  echo "$entry: $url -> $new"
  if [[ "$apply" == --apply ]]; then
    kc edit --url "$new" "$entry"
  fi
done
