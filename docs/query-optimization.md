# Search Query Optimization Guide

Guide for AI agents on how to construct effective search queries. Covers SearXNG syntax, Google-compatible operators, and query reformulation strategies.

## Core Principles

1. **Shorter is often better.** Search engines rank by keyword relevance, not sentence comprehension. Strip filler words.
2. **Keywords > natural language.** "python asyncio semaphore" beats "how do I use a semaphore in Python asyncio".
3. **One concept per query.** Split multi-topic questions into separate searches, then synthesize.
4. **Reformulate and retry.** If the first query misses, rephrase with different keywords — don't just add more of the same.

## Query Construction

### Step 1: Extract keywords

From the user's intent, pull out:
- **Entity names** (product, library, person, company)
- **Technical terms** (error message, API name, protocol)
- **Action verbs** (install, configure, compare, fix)
- **Version/edition** if relevant (v2.0, LTS, 64-bit)

Drop: articles, filler ("how to", "what is"), redundant words.

**Examples:**
| User intent | Keywords |
|---|---|
| "How do I set up OAuth2 in Next.js 14?" | `Next.js 14 OAuth2 setup` |
| "What's the difference between Redis and Valkey?" | `Redis vs Valkey comparison` |
| "Fix TypeError: cannot read property of undefined" | `TypeError cannot read property undefined` |
| "Best local LLM for code generation 2026" | `local LLM code generation 2026` |

### Step 2: Choose search mode

Match the query to the right mode:

| Intent | Mode | Why |
|---|---|---|
| Find official documentation | `official-docs` | Boosts docs.* and developer.* hosts |
| Find a GitHub repo or issue | `github` | Restricts to github.com |
| Find a model (HuggingFace etc.) | `models` | Boosts model hosts |
| Find a package (npm, PyPI) | `packages` | Boosts registry hosts |
| General question | `auto` | Let intent detection decide |

### Step 3: Apply operators when useful

Don't add operators for every query. Use them when the basic query returns too much noise.

## Google-Compatible Operators

These work through SearXNG when the underlying engine is Google, Bing, or DuckDuckGo.

### Exact phrase: `"..."`

Force the words to appear together, in order.

```
"connection pool exhausted"     ← exact error message
"react server components"       ← exact concept name
```

**When to use:** Error messages, exact product/feature names, quoted phrases.

### Exclude: `-word`

Remove results containing the word.

```
python async -django             ← async Python, not Django
kubernetes ingress -nginx        ← K8s ingress, not nginx-specific
```

**When to use:** Disambiguation (Apple fruit vs Apple company), removing irrelevant but common results.

### Site restriction: `site:domain`

Limit results to a specific site.

```
site:docs.python.org asyncio
site:github.com/typescript react
site:stackoverflow.com rust lifetime
```

**When to use:** When you know the authoritative source. SearXNG's `!` syntax can also do this (see below).

### File type: `filetype:ext`

Find specific file types.

```
kubernetes deployment filetype:yaml
machine learning roadmap filetype:pdf
react native template filetype:tsx
```

**When to use:** Looking for config templates, PDFs, slides, data files.

### Title match: `intitle:word` / `allintitle:word1 word2`

Word must appear in the page title.

```
intitle:tutorial rust ownership
allintitle:python asyncio guide
```

**When to use:** Filtering out pages that merely mention a topic vs. pages dedicated to it.

### URL match: `inurl:word`

Word must appear in the URL.

```
inurl:changelog react 18
inurl:api reference swift concurrency
```

**When to use:** Finding structured pages (changelogs, API docs, release notes).

### Date filter: `before:YYYY-MM-DD` / `after:YYYY-MM-DD`

Filter by publication date.

```
GPT-5 after:2026-01-01
python 2 end of life before:2021-01-01
```

**When to use:** Recent news, historical lookups, version-specific info.

### Boolean: `OR` / `AND` / `|`

```
(Redis OR Valkey) performance benchmark
React AND "server components" tutorial
```

**When to use:** Comparing alternatives, combining concepts.

### Combining operators

Operators chain naturally:

```
site:github.com "machine learning" filetype:md after:2025-01-01
intitle:changelog (React OR Next.js) -beta
```

## SearXNG-Specific Syntax

SearXNG adds its own prefixes on top of standard operators.

### Engine selection: `!engine`

```
!wp asyncio                    ← search Wikipedia for "asyncio"
!gh react hooks                ← search GitHub
!npm typescript                ← search npm
!ddg local LLM                ← search DuckDuckGo specifically
```

Chainable: `!gh !npm react native` searches both GitHub and npm.

### Category selection: `!category`

```
!map San Francisco             ← maps category
!images neural network diagram ← image search
!news AI regulation 2026       ← news category
```

### Language selection: `:lang`

```
:zh 量子计算                   ← Chinese results
:ja Rust 言語                  ← Japanese results
:fr !wp Paris                  ← French Wikipedia
```

### External bangs: `!!engine`

Redirects directly to the external engine (bypasses SearXNG).

```
!!wfr Python                   ← go directly to French Wikipedia
!!ghr rust                     ← go directly to GitHub repos
```

**Note:** External bangs bypass SearXNG privacy protection.

## Query Reformulation Strategies

When the first search doesn't return good results, try these in order:

### Strategy 1: Simplify

Remove modifiers and search with bare keywords.

```
Before: "how to properly configure nginx reverse proxy for websocket connections"
After:  nginx reverse proxy websocket
```

### Strategy 2: Synonym swap

Replace terms with alternatives.

```
Before: "javascript memory leak detection"
After:  javascript heap snapshot profiling
Before: "python HTTP client timeout"
After:  python requests timeout configuration
```

### Strategy 3: Narrow with specificity

Add version, platform, or context.

```
Before: "react hydration error"
After:  react 18 hydration mismatch SSR
Before: "rust compile error borrow checker"
After:  rust "cannot borrow as mutable" lifetime
```

### Strategy 4: Broaden with abstraction

Remove overly specific terms.

```
Before: "Next.js 14.2.3 app router middleware redirect not working"
After:  Next.js middleware redirect issue
```

### Strategy 5: Source redirect

Switch to a known-good source.

```
Before: python asyncio tutorial
After:  site:docs.python.org asyncio
```

### Strategy 6: Format shift

Search for a different content format.

```
Before: "kubernetes networking explained"       ← articles
After:  kubernetes networking filetype:pdf      ← PDFs/slides
After:  !images kubernetes networking diagram   ← diagrams
```

## Multi-Query Research Pattern

For complex questions, use a multi-step pattern:

1. **Broad discovery** — general query to understand the landscape
2. **Targeted lookup** — specific query to find the authoritative source
3. **Deep extraction** — fetch and read the specific page

```
Step 1:  "Redis vs Valkey 2026"              ← overview
Step 2:  site:valkey.io migration guide       ← official docs
Step 3:  Fetch the migration guide page       ← extract content
```

## Anti-Patterns

Things that hurt search quality:

- **Full sentences as queries.** "Can someone tell me how to use TypeScript generics?" → just `TypeScript generics tutorial`
- **Stacking synonyms.** "best top greatest amazing framework library tool" → pick one specific term
- **Too many operators at once.** Over-constraining returns zero results.
- **Ignoring the first page.** If page 1 results are all off-topic, reformulate instead of going to page 2.
- **Same query, different engine.** If Google misses, try a different query formulation, not just Bing.

## Quick Reference

| Goal | Query pattern |
|---|---|
| Official docs | `site:docs.PROJECT.io topic` or mode `official-docs` |
| GitHub repo | `site:github.com topic` or mode `github` |
| Error fix | `"exact error message" fix` |
| Comparison | `X vs Y comparison` or `X OR Y benchmark` |
| Recent info | `topic after:YYYY-MM-DD` |
| Config template | `topic filetype:yaml` or `filetype:json` |
| Package lookup | mode `packages` or `!npm` / `!pypi` |
| Model lookup | mode `models` or `site:huggingface.co` |
