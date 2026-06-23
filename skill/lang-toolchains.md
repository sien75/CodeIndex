# Language Toolchain Reference

When analyzing code, don't guess — use tools for precise information. Below are commonly used tools by language. Pick what's relevant for the current project.

## TypeScript / JavaScript

**Types and Semantics**
- `tsc --noEmit` — run a full type check to see if there are type errors, without actually emitting compiled files
- `tsserver` / TypeScript LSP — the "smart hints engine" behind your editor: query type inference, jump to definition, find references

**Syntax Structure**
- `tree-sitter` (typescript/javascript grammar) — parse source into a syntax tree; precisely know where a function starts and ends

**Search and Locate**
- `grep` / `ripgrep` — simplest but most reliable global search: find symbols, strings, import relationships

## Python

**Types and Semantics**
- `pyright` / `mypy` — Python type checkers that infer variable types and detect type mismatches
- `pylsp` / Pyright LSP — go to definition, find references, completions

**Syntax Structure**
- `tree-sitter` (python grammar) — parse class and function boundaries
- Python built-in `ast` module — `python -c "import ast; ..."` can also parse syntax trees, no extra install needed

**Search and Locate**
- `grep` / `ripgrep` — `rg "def function_name" --type py`

## Go

**Types and Semantics**
- `gopls` — Go's official LSP: type inference, go to definition, find references
- `go vet` — official static analysis, catches common errors the compiler misses
- `go build` — compile check

**Syntax Structure**
- `tree-sitter` (go grammar) — parse interface definitions, structs, function signatures

**Search and Locate**
- `grep` / `ripgrep` — `rg "func.*HandlerName" --type go`

## Java / Kotlin

**Types and Semantics**
- `jdtls` (Java) / `kotlin-language-server` — LSP: query types, jump to definition, find references
- `javac` / `kotlinc` — compile check

**Syntax Structure**
- `tree-sitter` (java/kotlin grammar) — parse annotations, class inheritance, method boundaries

**Search and Locate**
- `grep` / `ripgrep` — `rg "@RestController" --type java`

## Rust

**Types and Semantics**
- `rust-analyzer` — Rust's LSP: type inference, go to definition, find references, even expands macros
- `cargo check` — fast compile check without producing binaries
- `cargo clippy` — static lint, catches idiomatic issues

**Syntax Structure**
- `tree-sitter` (rust grammar) — parse trait implementations, module structure

**Search and Locate**
- `grep` / `ripgrep` — `rg "pub fn" --type rust`

## C / C++

**Types and Semantics**
- `clangd` — C/C++ LSP: type inference, go to definition, find references
- `clang` / `gcc` — compile check

**Syntax Structure**
- `tree-sitter` (c/cpp grammar) — parse header files, macro definitions, function signatures

**Search and Locate**
- `grep` / `ripgrep` — `rg "void.*function_name" --type cpp`

## Universal (all languages)

- `grep` / `ripgrep` — global search for symbols and strings, the most versatile tool
- `find` — locate files by name or extension
- `wc -l` — count lines
- `git log` / `git blame` — view change history, understand why code was written a certain way
- `tree` — quick directory structure overview
