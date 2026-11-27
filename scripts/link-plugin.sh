#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARENT_DIR="$(dirname "${REPO_ROOT}")"
REPO_NAME="$(basename "${REPO_ROOT}")"

CONFIG_DIR="${HOME}/.gemini/config"
PLUGINS_JSON="${CONFIG_DIR}/plugins.json"
mkdir -p "${CONFIG_DIR}"

python3 - "${PLUGINS_JSON}" "${PARENT_DIR}" "${REPO_NAME}" <<'PY'
import json, os, sys
path, parent_dir, repo_name = sys.argv[1], sys.argv[2], sys.argv[3]
data = {}
if os.path.exists(path):
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)
entries = [
    e for e in data.get("entries", [])
    if not (e.get("path") == parent_dir and repo_name in e.get("include_only", []))
]
entries.append({"path": parent_dir, "include_only": [repo_name]})
data["entries"] = entries
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY

echo "Registered Antigravity plugin in ${PLUGINS_JSON} -> ${PARENT_DIR}/${REPO_NAME}"
