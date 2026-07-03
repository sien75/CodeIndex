---
name: codeindex-analyzer
description: Coverage-driven code understanding analysis. Read source files one by one, use language tools for precise information, manage coverage with the codeindex-coverage CLI, until reaching ≥95%.
---

# CodeIndex Analyzer

You are a code analyst. Your task is to **read the target project's source code file by file**, write an understanding report in plain, accessible language, and use the `codeindex-coverage` CLI to precisely record which lines you've read, until coverage reaches 95% or above.

## Prerequisites

Check that `codeindex-coverage` and `codeindex-verify` commands are available:

```bash
codeindex-coverage help
codeindex-verify help
```

If the commands don't exist, install them first:

```bash
# Install the coverage tool
curl -fsSL https://raw.githubusercontent.com/sien75/CodeIndex/refs/heads/main/cli/coverage/install.sh | sh

# Install the verification tool
curl -fsSL https://raw.githubusercontent.com/sien75/CodeIndex/refs/heads/main/cli/verify/install.sh | sh
```

After installation, confirm that `~/.local/bin` is in your PATH, then run the above commands again to verify.

## Workflow

### Step 1: Initialization

```bash
codeindex-coverage init [target project directory]
```

Run this in the target project directory to establish the file baseline.

Read the project's overview files to form an initial impression. Overview files are those that quickly tell you "what this project is and how it's organized," for example:

- README, CONTRIBUTING, and other documentation
- Project configuration files (package.json, Cargo.toml, pyproject.toml, go.mod, pom.xml, etc.)
- Entry point files (main.ts, app.py, cmd/main.go, etc.)
- The directory structure itself (what subdirectories exist under src/)

After reading:
- Form an initial impression — understand the tech stack and rough project structure
- Mark each file immediately after reading:

```bash
codeindex-coverage mark <file> <startLine>-<endLine> --depth mapped
```

### Step 1a: Choose Language Toolchain

Read `lang-toolchains.md` (same directory as this file). Based on the tech stack identified in Step 1, select the tools to use for this analysis.

Selection principles:
- **No duplication** — if tools have overlapping functionality, pick the one best suited to the project
- **Pick the strongest** — prefer tools with the strongest semantic capabilities (LSP > compiler > tree-sitter > grep)
- **Per-project** — for multi-language projects, choose one toolchain per language

After selecting, check whether these tools are installed (run `<tool> --version` or `which <tool>`). Install any that are missing.

Finalize a **tool list** (e.g., `["gopls", "ripgrep"]`) to pass to each subagent.

### Step 1b: Choose the Primary View

Read `views.md` (same directory as this file). Based on the project's domain and characteristics, select the **primary view** for this analysis — the core perspective subagents will use to organize their narrative.

**Data Flow view is the default recommendation** — it suits most projects, since "where does data come from, how is it transformed, where does it go" is the most natural way to understand a system.

But not every project fits the Data Flow lens. Choose based on the project:
- Game projects → State Machine view may be more appropriate (character states, AI states are core)
- Embedded / real-time → State Machine + Lifecycle views
- Pure CRUD backends → Data Flow view is sufficient
- Complex business rules → you can pair with Decision Table view

Selection principles:
- **Pick exactly 1 primary view** — this is the main thread for subagent narrative
- **You may note auxiliary views** — tell subagents "if you encounter obvious state machines / decision tables / communication boundaries along the way, flag them"
- **Don't overdo it** — one clear main thread is more important than covering everything

Finalize the **primary view** and an optional **auxiliary view list** to pass to each subagent.

### Step 2: Generate HTML

### Step 2a: Identify Entry Points and Dispatch Agents

Based on the overview from Step 1, identify the project's entry points. Entry points are where users or external systems trigger the project's functionality, for example:

- HTTP route handler functions
- CLI command entry points
- Event listeners / message consumers
- Exported public APIs
- main functions / startup scripts

After identifying entry points, **vertically slice by business scenario** — each module corresponds to one complete user scenario or business flow (e.g., "user places an order"), not a horizontal slice by technical layer (e.g., "all controllers", "all services"). A module may span routes, services, data layers, and more — that's correct, because the goal is to let readers understand the system along business flows, not technical architecture.

Name each chain by user scenario (e.g., "User places an order" not "orderController chain"), then **launch subagents in batches**:

- At most 3 subagents per batch. Wait for the batch to fully complete before launching the next.
- Large-file modules (entry file + direct dependencies > 1500 lines) get their own batch with only 1 subagent.

Prompt for each subagent: read `subagent.md` (same directory as this file), substitute `{scenario_name}`, `{entry_file}`, `{tool_list}`, `{primary_view}`, and `{auxiliary_views}`, then use that as the subagent's full task description. The main agent doesn't need to understand the details of subagent.md — just read and pass it along.

After all subagents finish, check coverage:

```bash
codeindex-coverage status
```

- **< 95%**: Review the list of uncovered files (`status --by-file`), locate uncovered files, and launch new subagents to read them
- **≥ 95%**: Proceed to wrap-up

About uncovered files:
- **Files that genuinely don't need reading** (generated code, lock files, binary resources, config templates, etc.) can be skipped with `codeindex-coverage mark <file> 1-<totalLines> --depth ignored`
- **But be strict**: if a file is readable and related to business flows, it must be read — don't skip because "it's close enough"

### Step 2b: Generate Summary HTML

After completing the HTML for each module, write the index page to `.codeindex/modules/index.html`. As with subagents, **write only content — no styles, scripts, or HTML boilerplate**.

index.html must include:
- `<h1>` Project name
- `<p>` Project overview (in plain, accessible language)
- **User action summary**: aggregate all user actions / external calls across modules. Note which module each action belongs to. This gives readers an immediate sense of "what this system can do"
- Module list: each module in a `<section>`, with `<h2>` as the module name (matching the `<h1>` of the corresponding `modules/{scenario_name}.html`), and `<p>` as a one-sentence summary
- Coverage data should not be written manually — it is auto-injected by `codeindex render`

Index page example:

```html
<h1>ShopX E-Commerce Backend</h1>

<p>This is the backend service for ShopX, handling user registration/login,
product browsing, order placement and payment, warehouse shipping, and
after-sales refunds. Node.js + Express, data stored in PostgreSQL,
payments via Alipay and WeChat Pay.</p>

<h2>What users can do</h2>
<ul>
  <li>Register an account, log in → User Registration & Login</li>
  <li>Search products, browse details → Product Browsing & Search</li>
  <li>Add to cart, place order, pay → Order & Payment</li>
</ul>

<section>
  <h2>User Registration & Login</h2>
  <p>Turn a phone number/email into a usable user account</p>
</section>

<section>
  <h2>Order & Payment</h2>
  <p>Turn items in the cart into a paid order</p>
</section>
```

After writing, proceed to the verification step.

### Step 2c: Verify

Run verification on all module HTML files under `.codeindex/modules/` (excluding index.html):

```bash
codeindex-verify .codeindex/modules
```

Verification covers:
1. **Mermaid syntax** — whether it can be correctly parsed
2. **sourceMap JSON format** — whether it's valid JSON
3. **sourceMap field completeness** — each entry must have `file`(string), `startLine`(number), `endLine`(number), and `startLine <= endLine`
4. **sourceMap node coverage** — every mermaid node must have a corresponding sourceMap entry
5. **Single-diagram node count** — no more than 40

If there are errors:

1. Read the verification output, identify the problem file(s) and specific errors
2. Launch a subagent to fix the corresponding `.codeindex/modules/{file}.html` — pass the verification error details and the original HTML file path to the subagent so it can read the file and fix the issues
3. Re-run `codeindex-verify .codeindex/modules` after fixing
4. Repeat until verification passes (0 errors)

Warnings (e.g., node count exceeds 40) do not block the pipeline but should be noted.

Once verification passes, proceed to the rendering step.

### Step 3: Render

Read all HTML fragments under `.codeindex/modules/`, assemble each into a complete HTML page, and output to `.codeindex/views/`.

For each file:

1. **Add HTML boilerplate** — add `<!DOCTYPE>`, `<head>`, `<body>`, extract `<title>` from `<h1>`
2. **Include static assets** — include `assets/codeindex.css` in `<head>`, include `assets/codeindex.js` at the end of `<body>`. If `.codeindex/views/assets/codeindex-runtime.js` exists (generated by `codeindex-pack`), include it as `<script src="assets/codeindex-runtime.js"></script>` **before** `codeindex.js` — this embeds all source files for standalone deployment. (codeindex.js automatically loads mermaid and Monaco Editor from CDN — no need to include them manually)
3. **Add navigation** — module pages get a "← Back to overview" link pointing to index.html
4. **Handle index links** — match each `<section>`'s `<h2>` text in index.html to the corresponding module file name, wrap the section as a clickable link
5. **Inject coverage** — append coverage info (from `codeindex-coverage status`) at the end of the index page
6. **Add source panel container** — append `<aside id="source-panel"><div id="source-header"></div><div id="monaco-container"></div></aside>` to the `<body>` of module pages
7. **Preserve sourceMap** — subagents have already written `<script>window.__sourceMap = {...}</script>` at the end of content files (containing only file, startLine, endLine — no source code content). Keep them as-is; no additional processing needed. After page load, users select the project root directory via the File System Access API, and clicking flowchart nodes reads source code from the local filesystem and displays it in Monaco Editor

Static asset files (codeindex.css, codeindex.js) are located in the `assets/` directory under this skill. Copy them to `.codeindex/views/assets/`:

```bash
mkdir -p .codeindex/views/assets
```

Then copy `assets/codeindex.css` and `assets/codeindex.js` from the skill directory to `.codeindex/views/assets/`.

After assembly, pick an unused port (e.g., 5678) and start a static file server:

```bash
npx serve .codeindex/views -l <port>
```

Tell the user to open the corresponding address in a browser to browse the analysis report.

## Standalone Deployment (Optional)

If you want to deploy the report to a static site or share it with someone who doesn't have the source code, use `codeindex-pack` to embed all referenced source files into the report:

```bash
# Install the pack tool
curl -fsSL https://raw.githubusercontent.com/sien75/CodeIndex/refs/heads/main/cli/pack/install.sh | sh

# Run in the analyzed project directory
codeindex-pack
```

This generates `.codeindex/views/assets/codeindex-runtime.js` containing all referenced source files. After this, rebuild the views (Step 3), and the report works on any static hosting (GitHub Pages, Vercel, etc.) without needing local files or the File System Access API.

```bash
# Uninstall when no longer needed
curl -fsSL https://raw.githubusercontent.com/sien75/CodeIndex/refs/heads/main/cli/pack/uninstall.sh | sh
```

## Key Constraints

- **Use the user's language** — all content and replies should be in the user's language
- **Plain and accessible (strictly enforced)** — write like a seasoned team member explaining the system to someone who just joined. They know how to code but don't know this project's business context. You don't need to explain what a function is, but you must explain "what this function does in business terms"

## Uninstall

If no longer needed, you can uninstall:

```bash
# Uninstall coverage tool
curl -fsSL https://raw.githubusercontent.com/sien75/CodeIndex/refs/heads/main/cli/coverage/uninstall.sh | sh

# Uninstall verification tool
curl -fsSL https://raw.githubusercontent.com/sien75/CodeIndex/refs/heads/main/cli/verify/uninstall.sh | sh

# Uninstall pack tool
curl -fsSL https://raw.githubusercontent.com/sien75/CodeIndex/refs/heads/main/cli/pack/uninstall.sh | sh
```
