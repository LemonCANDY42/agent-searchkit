# Web Searcher — MCP Server Skill

## What this does

Exposes web-searcher as an MCP (Model Context Protocol) server, usable by any MCP-compatible agent (Claude Desktop, Cursor, Continue, etc.).

## Prerequisites

- Node.js 18+
- SearXNG running locally (default: `http://127.0.0.1:8888`)

## Setup

### 1. Clone and install

```bash
git clone https://github.com/LemonCANDY42/web-searcher.git
cd web-searcher
npm install
```

### 2. Configure your MCP client

Add to your MCP client config (e.g., `claude_desktop_config.json` or `.cursor/mcp.json`):

```json
{
  "mcpServers": {
    "web-searcher": {
      "command": "node",
      "args": ["path/to/web-searcher/src/index.ts"],
      "env": {
        "SEARXNG_BASE_URL": "http://127.0.0.1:8888"
      }
    }
  }
}
```

Replace `path/to/web-searcher` with the actual clone path.

### 3. Verify

Restart your MCP client. The following tools should appear:

| Tool | Description |
|------|-------------|
| `web_searcher_search` | Search with reranking |
| `web_searcher_research` | Checkpointed research |
| `web_searcher_extract` | Page extraction |
| `web_searcher_status` | Health check |

## Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `SEARXNG_BASE_URL` | `http://127.0.0.1:8888` | SearXNG URL |
| `DEFAULT_LANGUAGE` | `en-US` | Search language |
| `DEFAULT_LIMIT` | `8` | Results per query |

## Usage examples

Once configured, your agent can call:

```
web_searcher_search(query="TypeScript 5.5 new features", mode="official-docs")
web_searcher_search(query="Redis vs Valkey benchmark", category="it")
web_searcher_research(query="AI agent frameworks comparison 2026")
web_searcher_extract(url="https://example.com/article")
```

## Troubleshooting

- **No tools appear:** Check the path in your MCP config is correct
- **SearXNG errors:** Ensure SearXNG is running: `curl http://127.0.0.1:8888/search?q=test&format=json`
- **Timeout:** Increase `fetchTimeoutMs` in the tool call parameters
