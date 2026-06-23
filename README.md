# CodeIndex

> [中文版本](README-zh.md)

Coverage-driven code understanding toolkit.

It guides AI to read projects along real code paths, record source coverage, generate HTML comprehension reports with Mermaid flowcharts, and verify the quality of the LLM-generated diagrams and sourceMap data.

## Components

- **`skill/`** — Core usage guide and workflow: how to analyze projects, dispatch subagents, track coverage, verify reports, and render pages
- **`cli/coverage/`** — `ci-coverage`, for recording and tracking code reading coverage
- **`cli/verify/`** — `ci-verify`, for validating the quality of generated HTML reports

## Usage

Install the skill to get started:

```bash
npx skills add sien75/CodeIndex
```

Once installed, in the project you want to analyze, say:

```text
Use ci-analyzer to analyze this project
```

> Note: Project analysis consumes a significant amount of tokens.

When the analysis is complete, the Agent will prompt you to open a URL. Open it and link it to your local project directory — you'll then be able to browse the code understanding report with source code correspondence.
