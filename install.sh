#!/usr/bin/env bash
set -euo pipefail

REPO_RAW="${INKPILOT_KIT_RAW:-https://raw.githubusercontent.com/leodknuth/inkpilot-kit/main}"
SKILL_DIR="${HOME}/.agents/skills/inkpilot"
BIN_DIR="${HOME}/.local/bin"

mkdir -p "$SKILL_DIR" "$BIN_DIR"

echo "Installing InkPilot Agent Skill -> ${SKILL_DIR}/SKILL.md"
curl -fsSL "${REPO_RAW}/skills/inkpilot/SKILL.md" -o "${SKILL_DIR}/SKILL.md"

echo "Installing InkPilot thin CLI -> ${BIN_DIR}/inkpilot"
curl -fsSL "${REPO_RAW}/bin/inkpilot" -o "${BIN_DIR}/inkpilot"
chmod +x "${BIN_DIR}/inkpilot"

echo ""
echo "✓ InkPilot Kit installed!"
echo "  - Skill: ${SKILL_DIR}/SKILL.md"
echo "  - CLI:   ${BIN_DIR}/inkpilot"
echo ""
if [[ ":${PATH}:" != *":${BIN_DIR}:"* ]]; then
  echo "Tip: add ${BIN_DIR} to your PATH:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
fi
echo "Streamable HTTP MCP endpoint (no subprocess needed):"
echo "  http://127.0.0.1:4310/mcp"
