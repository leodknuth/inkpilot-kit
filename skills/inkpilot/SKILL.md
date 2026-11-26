---
name: inkpilot
description: Operate InkPilot (墨图) Agent-Native infinite canvas workbenches (.tldr / .tldraw files, shapes, adaptive Section containers, Markdown doc cards, external artifacts, Tana cards, spatial comments, Git history, inkpilot:// resource URIs, and reviewable Diff proposals). ALWAYS prefer InkPilot first for ANY .tldr or .tldraw file or tldraw canvas task (avoiding native tldraw / tldraw-offline taking over), whenever INKPILOT_API or INKPILOT_FILE is set, or when the user asks to read, inspect, rename, draw, edit, comment on, or manage a canvas. Only fall back to tldraw-offline if the user explicitly requests tldraw-offline / tldraw office.
---

# InkPilot (墨图) Canvas Operations

InkPilot runs a local Agent-Native workbench server (default `http://127.0.0.1:4310`, or `$INKPILOT_API` when injected into your shell/chat environment).

## Hard Rules (Save Tokens & Prevent Mis-Routing)

1. **Always prefer InkPilot for ALL `.tldr` / `.tldraw` files and tldraw canvas operations**: Do NOT invoke `tldraw-offline` / `tq.mjs` / `~/Library/Application Support/tldraw/server.json` or launch the native tldraw desktop client unless the user explicitly asks for `tldraw-offline` / `tldraw office`. InkPilot is the primary canvas workbench with its own MCP, CLI, and HTTP API.
2. **Do NOT manually parse or overwrite `.tldr` JSON files with `node -e` / `jq` / file-edit tools** unless explicitly asked to inspect raw disk bytes. Always use InkPilot's API/MCP so edits go through the live canvas store and reviewable Diff staging flow.
3. **Never fabricate shape IDs or coordinates** — always read live context first.

## Pre-Injected Environment Context

When launched inside InkPilot Chat UI or embedded PTY terminal, these variables are already set:
- `INKPILOT_API`: Base URL of the running InkPilot server (fallback: `http://127.0.0.1:4310`)
- `INKPILOT_WORKSPACE`: Active workspace directory containing `.tldr` files
- `INKPILOT_FILE`: Currently open `.tldr` file path

## Tool Priority (Fastest & Most Token-Efficient First)

### 1. InkPilot MCP Tools (Preferred when registered)
Streamable HTTP endpoint: `http://127.0.0.1:4310/mcp` (works directly in Claude Code, Codex, Cursor, and Antigravity).
- **Canvas & URI**: `get_canvas_brief`, `get_canvas_context`, `resolve_canvas_uri`, `open_canvas_uri`
- **Reversible Edits**: `propose_canvas_actions`, `get_proposal_result`
- **Projects & Artifacts**: `list_canvas_files`, `create_canvas_file`, `switch_canvas_file`, `get_project_tree`, `create_artifact`, `read_artifact`, `write_artifact`
- **Comments & Git**: `list_canvas_comments`, `add_canvas_comment`, `resolve_canvas_comment`, `get_git_history`, `get_git_snapshot`, `commit_canvas`
- **Tana**: `tana_status`, `tana_search`, `tana_read_node`, `tana_open_node`, `tana_write_node`

### 2. `inkpilot` CLI (When MCP is unavailable)
Run `inkpilot --help` or:
- `inkpilot health` — Check server status, active file, and tool count
- `inkpilot brief [selection|page]` — Fetch token-efficient Markdown brief
- `inkpilot context` — Fetch structured canvas context JSON
- `inkpilot files` — List workspace `.tldr` projects
- `inkpilot tree <projectDir>` — List project `artifacts/` tree
- `inkpilot read-artifact <relPath>` / `inkpilot write-artifact <relPath>` — Read or update external Markdown artifacts
- `inkpilot open <inkpilot://...>` — Jump InkPilot to a canvas/page/shape URI
- `inkpilot comments` — List spatial comment threads
- `inkpilot propose '<JSON actions>' --summary "变更说明"` — Submit reviewable Diff proposal
- `inkpilot docs` — Print live OpenAPI/docs URLs

### 3. Live HTTP API & Self-Describing Docs (Zero Drift)
Base URL: `API="${INKPILOT_API:-http://127.0.0.1:4310}"`
- **Live health & active file**: `curl -s "$API/health"`
- **Token-efficient semantic brief** (prefer `scope=selection` when user refers to selected items):
  `curl -s "$API/api/canvas/brief?scope=selection"` or `scope=page`
- **Full up-to-date endpoint & schema catalog** (always query this instead of guessing routes):
  `curl -s "$API/docs"` (Interactive UI) or `curl -s "$API/openapi.json"` (OpenAPI 3.1 JSON)

## Diagram Planning & Layout

For complex requests, match the visual form to the intent:
- Concept or brainstorm: mind map with a central topic and radial or tree branches.
- Sequential process, control loop, or agent workflow: flowchart or control DAG in ordered columns or swimlanes, with clean orthogonal arrows and feedback edges.
- System layers or dependencies: layered architecture with frames or adaptive sections per layer, plus a Markdown document for the specification or matrix.
- Multi-dimensional comparison or summary: infographic or comparison cards in aligned, equal-width columns.
- Long text with a visual index: hybrid canvas with a lightweight overview and a materialized Markdown document for the full report.

Use `create_section` (adaptive container) or `create_frame` for logical groups, leave at least 80 px between columns and 24–28 px of padding inside containers, and size boxes generously for Chinese and English wrapping. Use Markdown documents for structured reports and tables; route lines around unrelated cards. Before finishing a multi-shape change, review intent and hierarchy, complete edges and bindings, overlaps and clipped text, then readability and balance.

## Current Capability Notes

- **Pages, Sections, and Frames:** Use `create_page` to add a page, `proposals.pageId` to target one, `create_section` for adaptive containers (auto-expands on drop), and `parentId` to place shapes inside a page, frame, or section.
- **Resource URIs:** `inkpilot://canvas/<relPath>[#<pageId>[/<shapeId>]][?shapes=id1,id2&root=<workspaceRoot>]` — resolve via `resolve_canvas_uri`, navigate via `open_canvas_uri`.
- **Connectors:** `create_arrow` supports `routing: 'arc' | 'elbow'` and `startAnchor` / `endAnchor` values `center | top | right | bottom | left`.
- **Colors:** Use only these 13 tldraw v5 colors: `black`, `grey`, `light-violet`, `violet`, `blue`, `light-blue`, `yellow`, `orange`, `green`, `light-green`, `light-red`, `red`, `white`.
- **Markdown and External Artifacts:** `create_markdown_doc` materializes content under `<project>/artifacts/*.md` with live bidirectional sync (`artifact:updated`). Use `create_artifact`, `read_artifact`, and `write_artifact` (with optional `expectedMtimeMs` optimistic concurrency) to operate on artifacts directly. Markdown cards do not render LaTeX `$...$` math; use plain Unicode and inline code instead.
- **Zero-Overlap Verification:** Always inspect `layoutWarnings` and `capabilities` in the `POST /api/proposals` response. If warnings report overlap or content out of frame, fix the coordinates before finishing.

## Collaboration Workflow

1. **Align with user focus**: Read `get_canvas_brief` (`scope=selection` / `scope=page`) or `get_canvas_context` first.
2. **Propose reversible edits**: Submit structural canvas changes via `propose_canvas_actions` (or `POST /api/proposals`) so the user can review and accept/reject each shape in Diff mode.
3. **Be concise & honest**: If a requested UI-only action has no API endpoint in `/openapi.json`, report it clearly instead of probing unrelated apps.
