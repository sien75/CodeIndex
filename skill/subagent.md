# Scan Task

**Scenario: `{scenario_name}`, Entry: `{entry_file}`**

**Available tools: `{tool_list}`** (selected based on the project's tech stack and confirmed installed — use them directly)

**Primary view: `{primary_view}`** | **Auxiliary views: `{auxiliary_views}`**

Starting from the entry point, read and organize the narrative from the perspective of **`{primary_view}`**. Expand all paths when encountering branches, and mark boundaries when encountering external calls (databases, third-party services, message queues, etc.).

**Important: Always start from the user's / external caller's perspective.** First explain: what can the user (or external system) do in this scenario? What action triggers this chain? Then go into how the system handles it internally. Don't jump straight into internal implementation — readers need to first know "where am I, what is this about."

## a. Read source along the primary view

Start from the entry file and read progressively from the perspective of `{primary_view}`. Source code is ground truth.

## b. Use tools for precise information

Don't guess. When uncertain, confirm using **only the tools in `{tool_list}`**:

- **Uncertain types** → query type inference
- **Unclear function boundaries** → parse syntax structure
- **Who calls this function** → find references
- **Where is it defined** → go to definition

## c. Draw diagrams

Diagram this chain using the `{primary_view}` approach (nodes + edges).

- **Every node must bind to a source location**: `{file, startLine, endLine}`
- **Draw all branches** — error paths cannot be omitted
- Use plain language for node labels, not code terminology
- **One diagram = one flow**, use `graph TD` (top-down layout)
- **No more than 40 nodes per diagram** — if a flow has too many nodes, split into multiple sub-diagrams, each focusing on one logical section, with text explaining the connections

If you naturally encounter patterns mentioned in `{auxiliary_views}` along the way (e.g., obvious state machines, decision tables, communication boundaries), flag them, but don't actively hunt for them.

## d. Write plain-language descriptions

- **Module name**: one-sentence summary — **what turns into what**
- **Input**: business meaning, not type signature. E.g., "user's selected items + shipping address"
- **Output**: business meaning. E.g., "a paid order"
- **Notes**: supplementary details, one or two sentences each. E.g., "payment callback has signature verification to prevent forged notifications"

## e. Mark coverage

Mark immediately after reading each section of code:

```bash
# Read line by line, understood the logic
codeindex-coverage mark <file> <startLine>-<endLine> --depth deep

# Know the ownership but didn't expand line by line
codeindex-coverage mark <file> <startLine>-<endLine> --depth mapped

# Imports, blank lines, pure type definitions, etc.
codeindex-coverage mark <file> <startLine>-<endLine> --depth ignored
```

## f. Output

**Write as you analyze** to `.codeindex/modules/{scenario_name}.html`.

**You are only responsible for content** — the text to display, diagrams, and source mapping data. Do not write any styles, class names (except `mermaid`), HTML boilerplate (`<!DOCTYPE>`, `<head>`, `<body>`, etc.), or interactive behavior. These will be handled uniformly by the subsequent rendering step.

**The only exception** is the source map: you need to write a `<script>` tag that maps mermaid node IDs to source information (file path, line range, code snippet) on `window.__sourceMap`. Since you've already read the source during analysis, writing the snippets directly is the most efficient approach — no need for the rendering step to read files again.

**Append as you go**:
1. **Before starting analysis**: create the file, write `<h1>{scenario_name}</h1>` and a description paragraph
2. **After each round of a~e**: immediately append content (descriptions, mermaid diagrams)
3. **After everything is done**: write the `<script>` tag defining `window.__sourceMap` at the end of the file
4. This way, even if the process is interrupted, previously analyzed sections are already saved

### Allowed tags

| Tag | Purpose |
|-----|---------|
| `<h1>` | Scenario name (only one per file) |
| `<p>` | Description paragraphs |
| `<dl>` `<dt>` `<dd>` | Input / Output |
| `<pre class="mermaid">` | Flowchart (Mermaid syntax) |
| `<ul>` `<li>` | Supplementary notes list |
| `<script>` | Only for defining `window.__sourceMap`; no other logic |

Do not use any other tags, classes (except `mermaid`), data- attributes, or style attributes.

### Mermaid node ID conventions

Use kebab-case for node IDs (e.g., `create-order`, `check-stock`), because the source panel uses these IDs for source anchoring.

### Source mapping (window.__sourceMap)

At the end of the file, write a `<script>` tag defining the `window.__sourceMap` object. Each entry maps a mermaid node ID to its source location:

```html
<script>
window.__sourceMap = {
  "create-order": {
    "file": "src/order/create.ts",
    "startLine": 12,
    "endLine": 35
  },
  "check-stock": {
    "file": "src/order/stock.ts",
    "startLine": 8,
    "endLine": 22
  }
};
</script>
```

Field descriptions:
- `file`: relative path to the source file
- `startLine` / `endLine`: line range of the code in the file

**Each range must snap to a real code item boundary** (a function, method, struct, etc.), not a hand-eyeballed span. Use a tree-sitter parse or your language LSP to get exact item start/end lines — never guess. A range must not start or end inside a function body, and must not span more than one top-level item. If a node maps to several items, split it into one node per item.

### Output example

```html
<h1>Order Payment</h1>

<p>After confirming their cart, the user enters the payment flow. This module handles
integration with third-party payment platforms: first creating a pending order, then
calling Alipay/WeChat Pay APIs to get a payment URL. After the user pays, the platform
sends a callback notification, and we update the order status to "paid" while
notifying the warehouse to ship.</p>

<dl>
  <dt>Input</dt>
  <dd>User's selected items + shipping address + payment method</dd>
  <dt>Output</dt>
  <dd>A paid order (the warehouse receives a shipping notification)</dd>
</dl>

<pre class="mermaid">
graph TD
  create-order["Create Order"] --> check-stock["Check Stock"]
  check-stock --> stock-enough{"Enough stock?"}
  stock-enough -->|No| stock-fail["Return Out of Stock"]
  stock-enough -->|Yes| call-payment["Call Payment Platform API"]
  call-payment --> payment-ok{"Payment successful?"}
  payment-ok -->|Failed| payment-fail["Mark Payment Failed"]
  payment-ok -->|Success| update-status["Update Order Status to Paid"]
  update-status --> notify-warehouse["Notify Warehouse to Ship"]
</pre>

<ul>
  <li>Payment callback has signature verification to prevent forged notifications</li>
  <li>If no callback is received within 30 minutes, the system proactively queries the payment platform</li>
  <li>Every order status change also writes a ledger entry for reconciliation</li>
</ul>

<script>
window.__sourceMap = {
  "create-order": {
    "file": "src/order/create.ts",
    "startLine": 12,
    "endLine": 35
  },
};
</script>
```

## Writing style

Write like a seasoned team member explaining the system to someone who just joined. They know how to code but don't know this project's business logic and context.

So:
- Don't explain "what a function is" or "what an API is" — they already know that
- Do explain "what this function does in business terms", "why it's done this way", "where this step's input comes from"
- Avoid merely recounting code structure ("calls A, A calls B") — explain the business intent

**Don't write like this:**
> This module implements a file upload validation pipeline, receiving `input: Buffer, projectId: string` and validating through a middleware chain

**Write like this:**
> After the user selects a file and clicks upload, the system checks the file format and size — if it's too large or an unsupported format, it tells the user right away; only if everything checks out does it store the file

**Don't write like this:**
> This function initiates a payment request by calling PaymentGateway.createCharge()

**Write like this:**
> This step reaches out to Alipay/WeChat Pay to initiate the charge, then waits for a callback notification telling us whether the money arrived

## Key constraints

1. **Coverage is computed programmatically** — must call `codeindex-coverage` to mark; unmarked = unread
2. **Flowcharts must be complete** — all branches, error paths, and external calls must be drawn
3. **Every node must bind to a source location** — all mermaid nodes (including diamond decision nodes) must have corresponding entries in sourceMap
4. **No guessing** — when uncertain, use language tools to confirm
5. **Use the user's language** — all content should be in the user's language
6. **Plain and accessible** — like a patient veteran explaining the system to a newcomer, no jargon stacking
