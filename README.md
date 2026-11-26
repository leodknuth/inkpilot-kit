# InkPilot Kit (墨图 Agent 接入套件)

Public agent integration kit for **InkPilot (墨图)** — the Agent-Native infinite canvas workbench.

This repository distributes:
- **`skills/inkpilot/SKILL.md`** — Agent Skill for Claude Code, Codex, Cursor, Antigravity, and CodeBuddy.
- **`bin/inkpilot`** — Zero-dependency Node.js 20+ thin CLI talking to your local InkPilot server (`http://127.0.0.1:4310`).
- **`install.sh`** — One-line installer for macOS & Linux.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/leodknuth/inkpilot-kit/main/install.sh | bash
```

This installs:
- `~/.agents/skills/inkpilot/SKILL.md`
- `~/.local/bin/inkpilot`

## MCP Setup (Recommended, Zero Subprocess)

InkPilot exposes a built-in **Streamable HTTP MCP** endpoint directly on its local server:

```json
{
  "mcpServers": {
    "inkpilot": {
      "url": "http://127.0.0.1:4310/mcp"
    }
  }
}
```

## CLI Quick Reference

```bash
inkpilot health
inkpilot brief selection
inkpilot files
inkpilot tree my-project
inkpilot read-artifact my-project/artifacts/spec.md
inkpilot open "inkpilot://canvas/my-project/my-project.tldr#page:page"
inkpilot docs
```

## Live API Docs (Single Source of Truth)

When InkPilot is running locally:
- Interactive Docs: `http://127.0.0.1:4310/docs`
- OpenAPI 3.1 JSON: `http://127.0.0.1:4310/openapi.json`
- Streamable HTTP MCP: `http://127.0.0.1:4310/mcp`

## License

MIT
