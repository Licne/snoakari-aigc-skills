#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGINS_DIR="${HOME}/.gemini/config/plugins"
LINK_PATH="${PLUGINS_DIR}/snoakari-aigc-skills"

mkdir -p "${PLUGINS_DIR}"

if [ -L "${LINK_PATH}" ]; then
  rm "${LINK_PATH}"
elif [ -e "${LINK_PATH}" ]; then
  echo "Error: ${LINK_PATH} already exists and is not a symlink." >&2
  exit 1
fi

ln -s "${REPO_ROOT}" "${LINK_PATH}"
echo "Linked Antigravity plugin: ${LINK_PATH} -> ${REPO_ROOT}"
