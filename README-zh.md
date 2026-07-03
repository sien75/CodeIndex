# CodeIndex

覆盖率驱动的代码理解工具。

它让 AI 沿着真实代码路径阅读项目、记录源码覆盖率、生成带 Mermaid 流程图的 HTML 理解报告，并用校验工具检查 LLM 产物里的流程图和 sourceMap 是否可靠。

## 组成

- **`skill/`**：核心使用说明和工作流，包含如何分析项目、分发 subagent、记录覆盖率、校验报告、渲染页面
- **`cli/coverage/`**：`codeindex-coverage`，用于记录和统计代码阅读覆盖率
- **`cli/verify/`**：`codeindex-verify`，用于校验生成的 HTML 报告质量
- **`cli/pack/`**：`codeindex-pack`，用于把源码内嵌进报告，使其无需本地文件即可在任意静态站点运行

## 使用

安装 skill 即可使用，例如：

```bash
npx skills add sien75/CodeIndex
```

安装后，在需要分析的项目里说：

```text
使用 codeindex-analyzer 分析这个项目，并允许启动 subagent
```

> 注意：分析项目会消耗比较多的 token。

## 关联代码

分析完成后，报告要能对应到源码。两种方式：

### 注入运行时

把源码内嵌进报告，无需本地文件，可部署到任意静态站点。对 agent 说：

```text
用 codeindex-pack 把源码注入报告
```

### 关联本地文件

报告通过浏览器读取本地项目目录。分析完成后 Agent 会提示你打开 url，打开后关联到本地项目目录，即可对应代码阅读文档。

> **浏览器支持**：关联本地项目目录需要 [File System Access API](https://developer.mozilla.org/en-US/docs/Web/API/File_System_API)，目前仅 **Chrome**（以及基于 Chromium 的 Edge 等浏览器）支持。Safari 和 Firefox 暂不支持此功能。
