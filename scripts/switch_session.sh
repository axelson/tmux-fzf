#!/usr/bin/env bash
#set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "$TMUX_FZF_SESSION_FORMAT" ]]; then
    sessions=$(tmux list-sessions)
else
    sessions=$(tmux list-sessions -F "#S: $TMUX_FZF_SESSION_FORMAT")
fi

FZF_DEFAULT_OPTS=$(echo $FZF_DEFAULT_OPTS | sed -E -e '$a --header="select an action"')

current_session_name=$(tmux display-message -p "#S")
tmux_attached_sessions=$(tmux list-sessions | grep "$current_session_name" | grep -o '^[[:alpha:][:digit:]_-]*:' | sed 's/.$//g')
sessions=$(echo "$sessions" | grep -v "^$tmux_attached_sessions")
target_origin=$(printf "%s\n[cancel]" "$sessions" | eval "$CURRENT_DIR/.fzf-tmux $TMUX_FZF_OPTIONS")
target=$(echo "$target_origin" | grep -o '^[[:alpha:][:digit:]_-]*:' | sed 's/.$//g')
echo "$target" | xargs tmux switch-client -t
