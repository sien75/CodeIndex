# CodeIndex

> [中文版本](README-zh.md)

Coverage-driven code understanding toolkit.

It guides AI to read projects along real code paths, record source coverage, generate HTML comprehension reports with Mermaid flowcharts, and verify the quality of the LLM-generated diagrams and sourceMap data.

## Components

- **`skill/`** — Core usage guide and workflow: how to analyze projects, dispatch subagents, track coverage, verify reports, and render pages
- **`cli/coverage/`** — `codeindex-coverage`, for recording and tracking code reading coverage
- **`cli/verify/`** — `codeindex-verify`, for validating the quality of generated HTML reports
- **`cli/pack/`** — `codeindex-pack`, for embedding source files into the report so it works on any static host without local files

## Usage

Install the skill to get started:

```bash
npx skills add sien75/CodeIndex
```

Once installed, in the project you want to analyze, say:

```text
Use codeindex-analyzer to analyze this project, and allow starting subagents
```

> Note: Project analysis consumes a significant amount of tokens.

## Linking Code

Once the analysis is done, the report needs to map back to source code. Two ways:

### Inject Runtime

Embeds source files into the report — no local files needed, deployable to any static site. Tell the agent:

```text
Use codeindex-pack to inject the source into the report
```

### Link Local Files

The report reads your local project directory through the browser. When analysis is complete, the Agent will prompt you to open a URL. Open it and link it to your local project directory — you'll then be able to browse the report with source code correspondence.

> **Browser support**: Linking to a local project directory requires the [File System Access API](https://developer.mozilla.org/en-US/docs/Web/API/File_System_API), which is currently only supported in **Chrome** (and Chromium-based browsers like Edge). Safari and Firefox do not support this feature yet.
