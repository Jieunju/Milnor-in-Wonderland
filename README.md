# 实 Grassmann 流形的欧氏非嵌入问题 — LaTeX 工程

由 Notion 主稿（page id `411ecac8-3544-81e4-8480-ceb337f02db0`）复写而来。
只做语法与排版重整，不改数学内容；改动清单见 [EDITORIAL_LOG.md](EDITORIAL_LOG.md)。

## 文件

| 文件 | 作用 |
|---|---|
| `main.tex` | 导言区、封面、目录、`\input` 汇总 |
| `sections/00-abstract.tex` | 摘要、关键词、文档定位框 |
| `sections/00b-notation.tex` | 记号与约定（全局记号表） |
| `sections/01-intro.tex` | 1 引言 |
| `sections/02-geometry.tex` | 2 Grassmann 几何（切丛公式） |
| `sections/03-sw.tex` | 3 Stiefel–Whitney 类与嵌入障碍 |
| `sections/04-classical.tex` | 4 Oproiu、Hiller–Stong 的经典结果 |
| `sections/05-computation.tex` | 5 计算实例、对照表、Hiller 递归理想 |
| `sections/06-conclusion.tex` | 6 总结与进一步的问题 |
| `sections/90-appendix.tex` | 附录 A 写作进度与核验状态 |
| `sections/99-refs.tex` | 参考文献（`thebibliography`） |
| `build.bat` / `build.ps1` | 编译两遍并报告 overfull / undefined |
| `AGENT.md` | 自动修改与审阅循环的操作规程 |
| `push.bat` / `push.ps1` | 提交并推送到 GitHub |

## 编译

```
build.bat            :: 最省事
```

或手动：

```
xelatex main.tex
xelatex main.tex
```

需要 **XeLaTeX + ctex**（TeX Live 2026，`E:\texlive\2026`）。当前状态：19 页，
0 error，0 overfull hbox，0 undefined reference。

## 编辑约定

1. 数学内容不动：命题、证明步骤、结论强弱、引文归属都不改。
2. 只改断句、标点、术语、环境、编号、表格、参考文献格式。
3. 任何不得不触碰内容的改动，必须写进 `EDITORIAL_LOG.md` 的 C 类，并在 Notion 上
   单独提一条评论请作者确认。
4. 每次改完必须重编译；页数或 overfull 数量变化要记一笔。

## 发布到 GitHub

目标仓库：<https://github.com/Jieunju/Milnor-in-Wonderland>（公开，默认分支 `main`）。

**方式一（推荐，保留提交历史）**

1. 安装 [Git for Windows](https://git-scm.com/download/win)；
2. 双击本目录下的 `push.bat`，或运行
   `powershell -ExecutionPolicy Bypass -File push.ps1`；
3. 首次推送会弹出 GitHub 登录，授权后自动完成 `init → commit → push`。

**方式二（不装 Git）**

在仓库页面点 *Add file → Upload files*，把整个 `GrassmannNonEmbedding` 文件夹拖进去，
填写提交说明后提交。此方式没有逐次提交历史，但内容一致。

`.gitignore` 已排除 `*.aux`、`*.log`、`*.toc`、`*.synctex.gz` 等中间产物；
`main.pdf` 作为交付物**保留**在版本库中，便于直接取用。
