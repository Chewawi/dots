#!/bin/sh
# Symlink every file under home/ into $HOME.
# Anything already in the way is moved to ~/dots-backup.
# Usage: ./install.sh [-n]   (-n only prints what would happen)

set -eu

dry=
[ "${1:-}" = "-n" ] && dry=1

dots=$(cd "$(dirname "$0")" && pwd -P)
backup="$HOME/dots-backup"

run() {
	[ -n "$dry" ] || "$@"
}

cd "$dots/home"
find . -type f | sed 's|^\./||' | sort | while IFS= read -r f; do
	src="$dots/home/$f"
	dst="$HOME/$f"

	[ "$(readlink "$dst" 2>/dev/null || true)" = "$src" ] && continue

	if [ -e "$dst" ] || [ -L "$dst" ]; then
		bak="$backup/$f"
		[ -e "$bak" ] || [ -L "$bak" ] && bak="$bak.$(date +%Y%m%d%H%M%S)"
		run mkdir -p "$(dirname "$bak")"
		run mv "$dst" "$bak"
		echo "backup ~/$f"
	fi

	run mkdir -p "$(dirname "$dst")"
	run ln -s "$src" "$dst"
	echo "link   ~/$f"
done
