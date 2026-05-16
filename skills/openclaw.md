# Web Searcher — OpenClaw Plugin Skill

## What this does

Gives your OpenClaw agent local search, reranking, research pipelines, and page extraction — all running on your machine, no API keys needed.

## Install

```bash
openclaw plugins install clawhub:web-searcher
openclaw config set plugins.entries.web-searcher.enabled true
openclaw config set plugins.entries.web-searcher.config.searxngBaseUrl "http://127.0.0.1:8888"
openclaw gateway restart
```

## Verify

```bash
# Check plugin loaded
openclaw status | grep web-searcher

# Run smoke test
cd ~/.openclaw/workspace/services/web-searcher
./manage.sh test
```

## Tools available after install

| Tool | What it does |
|------|-------------|
| `web_searcher_search` | Search with multi-version reranking |
| `web_searcher_research` | Checkpointed deep research runs |
| `web_searcher_extract` | Page extraction (fetch + Playwright) |
| `web_searcher_status` | Stack health check |

## Usage patterns

### Basic search
```
Use web_searcher_search to find "React 19 new features"
```

### Search with options
```
Use web_searcher_search with query="asyncio semaphore", mode="official-docs", language="en-US"
```

### Deep research
```
Use web_searcher_research to research "local LLM inference benchmarks 2026"
```

### Page extraction
```
Use web_searcher_extract to extract content from https://example.com/article
```

## Configuration

Set in `openclaw.json` under `plugins.entries.web-searcher.config`:

| Key | Default | Description |
|-----|---------|-------------|
| `searxngBaseUrl` | `http://127.0.0.1:8888` | SearXNG instance URL |
| `defaultLanguage` | `en-US` | Default search language |
| `defaultLimit` | `8` | Results per query |
| `rerankEnabled` | `true` | Enable reranking |
| `defaultRerankVersion` | `v1.4` | Rerank version |
| `defaultMode` | `auto` | Default search mode |

## Troubleshooting

- **SearXNG not responding:** `./manage.sh up` to start the stack
- **No results:** Check SearXNG is running on the configured port
- **Slow searches:** First query after restart is slower (SearXNG warm-up)
