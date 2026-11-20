#!/usr/bin/env bash
# The only command the GitHub Actions deploy key may run, installed as
# /usr/local/bin/foxdrop-deploy-ssh by provision.sh and named in the key's
# `command=` in /home/foxdrop-deploy/.ssh/authorized_keys. It passes a
# well-formed request to foxdrop-deploy through sudo, and nothing else.
set -euo pipefail

request=${SSH_ORIGINAL_COMMAND:-}
# Slice 2.44: the restaurant app's Windows release, a tar on standard input.
if [[ $request =~ ^(staging)\ windows$ ]]; then
  exec sudo --non-interactive /usr/local/bin/foxdrop-windows-publish "${BASH_REMATCH[1]}"
fi
if [[ $request =~ ^(staging)\ ([0-9a-f]{40}|rollback)$ ]]; then
  exec sudo --non-interactive /usr/local/bin/foxdrop-deploy "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}"
fi
echo "usage: staging <commit> | staging rollback | staging windows" >&2
exit 2
